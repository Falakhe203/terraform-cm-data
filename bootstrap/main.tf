resource "aws_iam_role" "cm-data-cross-account-deployment-role" {
    name = "${var.cm_data_prefix}-cross-account-deployment-role"
    assume_role_policy = templatefile(
        "${path.module}/policies/cross-account-deployment-assume-role-policy.json.tpl", {
        aws_tooling_account_id = var.aws_tooling_account_id
        stage = var.stage
        }
    )
}

resource "aws_iam_role_policy_attachment" "cm-data-cross-account-deployment-role-AdministratorAccess" {
    role = aws_iam_role.cm-data-cross-account-deployment-role.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_policy" "source-layer-access" {
    count = var.mft_connection_available == true ? 1 : 0

    name = "${var.cm_data_prefix}-source-layer-access"
    description = "This policy grants read and write access for cm source layer bucket"
    policy = templatefile(
        "${path.module}/policies/source_layer_access.json", {
           source_layer_s3_bucket = var.cm_data_source_layer.cdh_s3_bucket,
           source_layer_kms_key_arn = var_cm_data_source_layer.cdh_s3_kms_key_arn   
        }
    )
}

resource "aws_iam_user_policy_attachment" "source-layer-access-attach" {
    count = var.mft_connection_available == true ? 1 : 0

    user = "service.cm_mft_${var.stage}_technical"
    policy_arn = aws_iam_policy.source-layer-access[0].arn
}
