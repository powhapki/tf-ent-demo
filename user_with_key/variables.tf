# Every variables in here can be set as a Terraform Variable at TFE. 
# Using Terraform Variables on TFE is more secure way and recommended.
variable "hostname" {
    default = "app.terraform.io"
}

variable "token" {
    default = "asdasdasdasdasd"
}

variable "ws_name" {
    default = "c-w-002"
}

variable "org_name" {
    default = "jsp-kr"
}

variable "user_name" {
    default = "c-w-005"
}

variable "vcs_token" {
    default = "ot-QuYBeasasdasdasd"
}

variable "repo_id" {
    default = "jsp-hashicorp/tf-sec-demo"
}

# This variables can be set as an Environment Variables at TFE either sensitive or not.
variable "region" {
    default = "ap-northeast-2"
}

variable "access_key" {
    default = "AKIA266ASDSDFSDFSDF"
}

variable "secret_key" {
    default = "tsdfsdfsdf90isd09sdf0sdf09sdf"
}
