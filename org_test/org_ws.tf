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
  # Personal Access Token is used for this setting
  oauth_token      = "asdasdasdasdasdasd" 
  service_provider = "github"
}

# Creating WorkSpace on Existing Org.
resource "tfe_workspace" "test" {
  name         = var.ws_name
  organization = tfe_organization.test.name

  #vcs_repo {
  #    identifier = 	var.repo_id  
  #    oauth_token_id = var.vcs_token
  #}
}
