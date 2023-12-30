import datetime
import json 
import os

import requests
TEAMS_WEBHOOK_URL = os.getenv("TEAMS_WEBHOOK_URL")
PIPELINE_EXECUTION_ID = os.geten("PIPELINE_EXECUTION_ID")
PIPELINE_NAME = os.getenv("PIPELINE_NAME")
PIPELINE_ACTION_NAME = os.getenv("PIPELINE_ACTION_NAME")


def fetch_git_metadata():
    git_metadata = {
    "project": "unknown",
    "repo": "unknown",
    "commit_ref": "unknown",
    "commit_hash": "unknown",
    "commit_summary": "unknown",
    "author_name": "unknown",
    "author_time": "unknown",
    "committer_name": "unknown",
    "commiter_date": "unknown",
    "s3_export_date": "unknown",
}
    with open(".git-metadata.json", "r") as f:
        s = f.read()
        git_metadata = json.loads(s)
        return git_metadata

def handler():
    metadata = fetch_git_metadata()
    print(
        "Server_response: "
        +str(
            request_teams(
                TEAMS_WEBHOOK_URL,
                "CodePipeline: {} approval required".format(PIPELINE_NAME),
                PIPELINE_EXECUTION_ID,
                PIPELINE_ACTION_NAME,
                PIPELINE_NAME,
                (datetime.datetime.now() + datetime.timedelta(days=6.5)).isoformat(),
                metadata["project"],
                metadata["repo"],
                metadata["commit_ref"],
                metadata["commit_hash"],
            )
        )
    )

def request_teams(
        webhookurl,
        title,
        execution_id,
        pipeline_action,
        pipeline_name,
        timeout,
        bb_project,
        bb_repo,
        bb_commit_ref,
        bb_commit_hash,
        color="000000",
):
    response = requests.post(
        url=webhookurl,
        headers={"Content-Type": "application/json"},
        json={
            "themeColor": color,
            "summary": title,
            "sections": [
                {
                    "activityTitle": title,
                    "activitySubtitle": "CodePipeline has been started by BitBucket and requires an approval",
                    "facts": [
                        {
                            "name": "Execution ID",
                            "value": execution_id,
                        },
                        {
                            "name": "Pipeline Name",
                            "value": pipeline_name,
                        },
                        {"name": "Pipeline Action", "value": pipeline_action},
                        {"name": "Project", "value": bb_project},
                        {"name": "Repository", "value": bb_repo},
                        {"name": "Commit Ref", "value": bb_commit_ref},
                        {"name": "Commit Hash", "value": bb_commit_hash},
                        {"name": "Expires at", "value": timeout},
                    ],
                }
            ],
            "potentialAction": [
                {
                    "@type": "OpenUrl",
                    "name": "Gotto pipeline",
                    "targets": [
                        {
                            "os": "default",
                            "uri": "https://eu-west-1.console.aws.amazon.com/codesuite/codepipeline/piplines/{}/view?region=eu-west-1".format(
                                pipeline_name
                            ),
                        }
                    ],
                }
            ],
        },
    )
    return response.status_code

if __name__ == "__main__":
    handler()