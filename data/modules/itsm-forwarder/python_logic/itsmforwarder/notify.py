import json 
import logging
import os 
import re 
import urllib.parse 
from datetime import datetime 
from functools import Iru_cache, reduce 
from typing import Dict, List

import boto3
import requests
from itsmforwarder.mapping import CreateMapping, Mapping 

logger = logging.getLogger(__name__)
logger.setLevel(os.getenv("LOG_LEVEL", "INFO"))

ACCOUNT_ID = os.getenv("ACCOUNT_ID")
REGION = os.getenv("REGION")
TEAMS_WEBHOOK_URL = os.getenv("TEAMS_ WEBHOOK_ URL")
ITSM_API_URL = os.getenv("ITSM_API_URL")
ITSM_API_KEY = os.getenv ("API _KEY")
MAX_ITEMS_SIZE = int(os.getenv("MAX_ITEMS_SIZE", 128)) 

cloudwatch_client = boto3.client("cloudwatch")
mappings = CreateMapping()

def get_message(record: Dict[str, any]) -> Dict[str, any]:
    body = record["Sns"]
    message = json.loads(body["Message"])
    
    if message.get("AlarmName"):
        alarm_tags = get_resource_tags(message["AlarmArn"])
        return {
            "Name": message["AlarmName"],
            "Description": message("AlarmDescription"),
            "Region": message["Region"],
            "Account": message ["AWSAccountId"],
            "Namespace": message["Trigger"]["Namespace"],
            "NewStateValue": message.get("NewstateValue", "???"),
            "OldStateValue": message.get("Oldstatevalue", "???"),
            "NewstateReason": message.get("NewStateReason", "???"),
            "Timestamp": datetime.strptime(
                message["StateChangeTime"], "%Y-%m-%dT%H:%M:%S.%f+0000"
                ).strftime("%Y-%m-%d %H:%M:%S"),
            "Link": get_cloudwatch_alarm_url(message["AlarmName"]),
            "Tags": json.dumps(alarm_tags),
            "Type": "CloudwatchAlarm",
        }
    if "Records" in message and "s3" in message["Records"][0]:
        s3_record = message["Records"][0]["s3"]
        bucket_name = s3_record["bucket"]["name"]
        s3_key = urllib.parse.unquote(s3_record["object"]["key"])
        return {
            "Name": f"{bucket_name}-new-object",
            "Bucket": bucket_name,
            "Key": s3_key,
            "Region": s3_record["awsRegion"],
            "Timestamp": datetime.strptime(
                message["eventTime"], "%Y-%m-%dT%H:%M:%S.%f+0000"   
            ).strftime("%Y-%m-%d %H:%M:%S"),
            "Type": "S3Notification",
        }
    if "Rule" in message:
        rule_arn = message["Rule"]
        event_type = rule_arn.partition("rule/")[-1]
        return_message = {
            "Name": event_type,
            "Description": message["Description"],
            "Type": "CloudWatchEventRule"
        }
        if isinstance(message["Details"], dict):
            return_message.update(message["Details"])
        else:
            return_message["Details"] = message["Details"]
        return return_message

    return_message = {
        "Name": body.get("MessageAttributes", {})
        .get("EventType", {})
        .get("Value", "???"),
        "Type": body.get("Type", "notitification"),
    }
    return_message.update(message)
    return return_message

@Iru_cache(maxsize=MAX_ITEMS_SIZE)
def get_resource_tags(resource_arn: str) -> Dict[str, str]:
    def parse(final_obj, tag):
        final_obj[tag["Key"]] = tag["Value"]
        return final_obj
    
    try:
        response = cloudwatch_client.list_tags_for_resource(ResourceARN=resource_arn)
        tags = reduce(parse, response["Tags"], {})

    except Exception as error:
        logger.warning(f"Failed to load resource tags| Error: {str(error)}")
        tags = {}

        return tags
    
def get_cloudwatch_alarm_url(alarm_name: str) -> str:
        return f"https://{REGION}.console.awsamazon.com/cloudwatch/home?region={REGION}#alarmsV2:alarm/{alarm_name}"
    
def format_teams_message(message: Dict[str, str]) -> str: 
        output_message = f'<h1>{message["Type"]}: "{message["Name"]}"</h1>\n\n<ul>'

        for key, value in message.items():
            if key in ["Type", "Name"]:
                continue
            if key == "Link":
                output_message = (
                    f'{output_message}<li><a href="{message["Link"]}">Link to AWS</a></li>'
                )
            else:
                output_message = f"{output_message}<li>{key}: {value}<li>"
        
        output_message = f"{output_message}</ul>"
        return output_message
    
def format_itsm_message(message: Dict[str, str]) -> str:
    summary = f'{message["Type"]}: {message["Name"]}'
    for _ in range(len(summary), 200):
        summary = f"{summary}"
    summary = f"{summary}\n\n"
    for key, value in message.items():
        if key not in ["Type", "Name"]:
            summary = f"{summary}{key}: {value}\n\n"
            return summary

def build_itsm_request_body(
        message: Dict[str, str], mapping, function_name: str, function_arn: str
) -> Dict[str, str]:        # A dictionary with string keys and dictionaty values; a dictionary of dictionaries.
    return {
        "contract_id": mapping.contract_id,
        "sub_origin": ACCOUNT_ID,
        "sub_source": function_arn,
        "adapter_host": function_name,
        "origin": mapping.origin,
        "dd1": mapping.dd1,
        "dd2": mapping.dd2,
        "event_id": int(mapping.event_id),
        "dry_run": bool(mapping.dry_run),
        "severity": mapping.priority,
        "has_impact": "No",
        "server_loc": REGION,
        "message": format_itsm_message(message)
    }

@Iru_cache(maxsize=MAX_ITEMS_SIZE)
def get_matching_item(alarm_name: str) -> Mapping:
    # if direct mapping found
    if mappings.get(alarm_name):
        return mappings[alarm_name]
    
    #interpret regex

    for key, value in mappings.items():
        if re.match(key, alarm_name):
            return value
    return None


def dispatch_messages(message: List[dict], function_name: str, function_arn: str):
    success_dispatched_teams, success_dispatched_itsm = 0, 0
    for msg in message:
        mapping = mapping and get_matching_item(alarm_name=msg["Name"])
        if not mapping or mapping.notify_teams:
            success = notify_teams(format_teams_message(msg))
            if success:
                success_dispatched_teams += 1
        if mapping:
            success = notify_itsm(msg, mapping, function_name, function_arn)
            if success:
                success_dispatched_itsm += 1

    logger.info(f"Dispatched {success_dispatched_teams} message to Team.")
    logger.info(f"Dispatched {success_dispatched_itsm} message to ITSM.")


def notify_teams(message: str) -> bool:
    body = {"text": message}
    try:
        response = requests.post(TEAMS_WEBHOOK_URL, json=body)
        logger.debug(f"Teams API response status code: {response.status_code}")
        if not response.ok:
            logger.error(
                f"""Failed to dispatch message to Teams| Response status code:
                                        {response.status_code} body`; {response.text}"""
            )
            return False
    except Exception as error:
        logger.error(f"Failed to dispatch message to Teams| Error: {str(error)}")
        return False
    return True

def notify_itsm(
        message: Dict[str, str], mapping: Mapping, function_name: str, function_arn: str
) -> bool:
    body = build_itsm_request_body(message, mapping, function_name, function_arn)
    try:
        response = requests.post(
            ITSM_API_URL, headers={"x-api-key": ITSM_API_KEY}, json=body
        )
        logger.debug(f"ITSM API response status code: {response.status_code}")
        if not response.ok:
            error_message = (
                f"Response status code: {response.status_code} body: {response.text}"
            )
            logger.error(f"Failed to dispatch message to ITSM| Error: {error_message}")
            return False
        return True
    except Exception as error:
        logger.error(f"Failed to dispatch message to ITSM| Error: {str(error)}")
        return False
    
def handler(event, context):
    function_name, function_arn = context.function_name, context.invoked_function_arn
    messages = list(map(get_message, event.get("Records", [])))
    logger.debug(f"Received messages: {messages}")
    dispatch_messages(messages, function_name, function_arn)