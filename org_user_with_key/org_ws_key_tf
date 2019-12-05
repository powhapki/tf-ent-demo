provider "tfe" {
    hostname = var.hostname
    token = var.token
}

# creating Org for workspaces
resource "tfe_organization" "test" {
  name = var.vd_org
  email = "test@test.com"
}

# creating VCS Integration for the Org.
resource "tfe_oauth_client" "test" {
  organization     = tfe_organization.test.name
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.p_token
  service_provider = "github"
}

# Creating WorkSpace on Existing Org.
resource "tfe_workspace" "test" {
  name         = var.ws_name
  organization = tfe_organization.test.name

  vcs_repo {
      identifier = 	var.repo_id  
      oauth_token_id = tfe_oauth_client.test.oauth_token_id
  }
}

# Setting AWS ACCESS KEY ID to Workspace
resource "tfe_variable" "access_key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = aws_iam_access_key.key_test.id
  category     = "env"
  sensitive    = true
  workspace_id = tfe_workspace.test.id
}

# Setting AWS SECRET ACCESS KEY To Workspacke
resource "tfe_variable" "secret_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = aws_iam_access_key.key_test.secret
  category     = "env"
  sensitive    = true
  workspace_id = tfe_workspace.test.id
}

resource "tfe_variable" "confirm_destroy" {
  key          = "CONFIRM_DESTROY"
  value        = "1"
  category     = "env"
  workspace_id = tfe_workspace.test.id
}
