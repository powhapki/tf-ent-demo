provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create AWS IAM User for WorkSpace
resource "aws_iam_user" "key_test" {
  name = var.user_name
}

# Creating AWS ACCESS KEY and SECRET ACCESS KEY under a specified user.
resource "aws_iam_access_key" "key_test" {
    user = aws_iam_user.key_test.name
}

resource "aws_iam_user_policy" "key_test" {
  name = "test"
  user = aws_iam_user.key_test.name
# Assign Proper policy along with Samsung VD Internal Policy. 
# Below is an example for assiging EC2 policy to user.
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

provider "tfe" {
    hostname = var.hostname
    token = var.token
}

# Creating WorkSpace on Existing Org.
#
resource "tfe_workspace" "test" {
  name         = var.ws_name
  organization = var.org_name
  
  vcs_repo {
      identifier = 	var.repo_id  
      oauth_token_id = var.vcs_token
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
