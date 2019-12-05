# Result of creating Workspace and setting ENV. Variable
#output "Org_name" {
#    value = tfe_organization.test.name
#}

#output "Org_token" {
#    value = tfe_organization_token.test.token
#}

output "workspace_id" {
    value = tfe_workspace.test.id
}

output "iam_user" {
    value = aws_iam_user.key_test.name
}

output "access-key" {
    value = tfe_variable.access_key.value
}

output "secret-key" {
    value = tfe_variable.secret_key.value
}
