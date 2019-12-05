# Result of creating Workspace and setting ENV. Variable
output "workspace_id" {
    value = tfe_workspace.test.id
}

output "access-key" {
    value = tfe_variable.access_key.value
}

output "secret-key" {
    value = tfe_variable.secret_key.value
}
