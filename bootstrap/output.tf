output "cross_account_role_name" {
    description = "Name of cross-account deploymeny role"
    value = aws_iam_role_role.cm-data-cross-account-deployment-role.name
}
