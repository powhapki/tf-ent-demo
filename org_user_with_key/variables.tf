# Every variables in here can be set as a Terraform Variable at TFE. 
# Using Terraform Variables on TFE is more secure way and recommended.
variable "hostname" {
    default = "app.terraform.io"
}

variable "token" {
    default = "TFE TOKEN"
}

variable "ws_name" {
    default = "c-w-006"
}

variable "vd_org" {
    default = "sec-vd-test001"
}

variable "user_name" {
    default = "c-w-006"
}

variable "p_token" {
    default = "GitHub OAuth Token"
}
variable "repo_id" {
    default = "jsp-hashicorp/jsp-hashicorp.github.io"
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
