# Every variables in here can be set as a Terraform Variable at TFE. 
# Using Terraform Variables on TFE is more secure way and recommended.
variable "hostname" {
    default = "TFE_HOST_NAEM"
}

variable "token" {
    default = "TFE TOKEN"
}

variable "ws_name" {
    default = "WS_NAME"
}

variable "vd_org" {
    default = "ORG_NAME"
}

variable "user_name" {
    default = "AWS_IAM_USER_NAME"
}

variable "vcs_token" {
    default = "OAuth Token ID from TFE VCE Integration"
}

variable "repo_id" {
    default = "GitHub Repo :org/:repo"
}

# This variables can be set as an Environment Variables at TFE either sensitive or not.
variable "region" {
    default = "ap-northeast-2"
}

variable "access_key" {
    default = "AWS_ACCESS_KEY"
}

variable "secret_key" {
    default = "AWS_SECRET_ACCESS_KEY"
}
