# TFE WorkSpace 생성 및 환경 변수 설정 자동화
본 문서는 Terraform Enterprise 사용 시 Organization과 WorkSpace 생성 작업을 자동화하는 목적으로 작성된 스크립트를 설명하고자 합니다.

현재 설명되는 모든 내용은 최종 작업 결과물을 바탕으로 하고 있다. 최종 작업 결과는 org_user_with_key 디렉토리에 저장되어 있다. 


> 참고 사항  
> 현재 Repo상에 있는 configuration template은 CLI 및 GUI 기반으로 모두 호환됩니다.
> 단, GUI 사용 시 해당하는 Terraform Variable을 사용할 것을 권장드립니다. 


## 작업 순서
전체 작업 순서는 다음과 같다. 
사전 작업 내용은 variable.tf에 기본적으로 저장하여 사용하며, GUI 기반 사용 시 Terraform Variable을 설정하여 Override할 수 있다.

1. 사전 작업
   1. AWS 정보 확인
   2. VCS 연동을 위한 정보 확인
   3. TFE 정보 확인
2. 본 작업
   1. AWS IAM 계정 및 ACCESS KEY 생성
   2. TFE Organization 및 WorkSpace 생성



## 1. 사전 작업

### 1.1 AWS 정보 확인
서비스 배포 시 사용할 region을 확인하고, AWS IAM User 생성 작업 시 사용할 계정의 Access key와 Secret Access key값을 확인하여 [variables.tf](org_user_with_key/variables.tf)에 설정한다.
```hcl
variable "region" {
    default = "ap-northeast-2"
}

variable "access_key" {
    default = "AWS_ACCESS_KEY"
}

variable "secret_key" {
    default = "AWS_SECRET_ACCESS_KEY"
}
```

### 1.2 VCS 연동을 위한 정보 확인
Organization 생성 시 VCS 연동을 위해 GitHub의 OAuth Token과 사용할 Repo 정보를 확인 후 [variables.tf](org_user_with_key/variables.tf)에 설정한다.

```hcl
variable "p_token" {
    default = "GitHub OAuth Token"
}
variable "repo_id" {
    default = "GitHub Repo in :org/:repo format"
}
```

### 1.3 TFE 정보 확인
작업 대상 TFE 정보를 확인 후 [variables.tf](org_user_with_key/variables.tf)에 설정한다.

```hcl
variable "hostname" {
    default = "app.terraform.io"
}

variable "token" {
    default = "TFE TOKEN"
}
```


## 2. 본 작업
### 2.1 AWS IAM 계정 및 ACCESS KEY 생성

1. 생성할 사용자 계정 이름은 [variables.tf](org_user_with_key/variables.tf)에 설정한다.

```hcl
variable "user_name" {
    default = "AWS_IAM_USER_NAME"
}
```
2. AWS IAM 계정과 ACCESS KEY를 생성한 configuration template을 작성한다. ([c_user.tf](org_user_with_key/c_user.tf))

계정 생성 시 기존 정책 또는 신규 정책 생성 후 할당한다.

```hcl
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

# Assign Proper policy along with Samsung VD Internal Policy. 
# Below is an example for assiging EC2 policy to user.
resource "aws_iam_user_policy" "key_test" {
  name = "sec_test_001"
  user = aws_iam_user.key_test.name

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
```

### 2.2 TFE Organization 및 WorkSpace 생성

생성할 Organization과 WorkSpace 이름은 [variables.tf](org_user_with_key/variables.tf)에 설정한다.

```hcl
variable "ws_name" {
    default = "WORKSPACE_NAME"
}

variable "vd_org" {
    default = "ORGANIZATION_NAME"
}
```
다음 작업을 수행할 configuration template 파일을 작성한다. ([org_ws_key.tf](org_user_with_key/org_ws_key.tf))

1. Organization 및 WorkSpace 생성

```hcl
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
# 기 생성된 조직 아래 WorkSpace를 생성하는 경우, tfe_organization과 tfe_oauth_client 생성없이 작업할 것.
# 단, 이때 oauth_token_id는 VCS Integration에서 확인 후 설정 필요
resource "tfe_workspace" "test" {
  name         = var.ws_name
  organization = tfe_organization.test.name

  vcs_repo {
      identifier = 	var.repo_id  
      oauth_token_id = tfe_oauth_client.test.oauth_token_id
  }
}
```

2. WorkSpace에 환경 변수로 AWS Access Key 정보 설정

```hcl
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
```


## 적용 시 고려 사항
최초 1회는 CLI 기반으로 이후에는 생성된 WorkSpace를 활용하여 작업하면 보다 손 쉽게 작업할 수 있다.

GUI기반 작업 시 설정이 필요한 Terraform 변수는 다음과 같다.

 변수명 | 설명
 -----| -------------
hostname| TFE FQDN Hostname
token | TFE Token (Settings > Tokens에서 생성)
vd_org | Organization 이름
ws_name | Workspace 이름
user_name | AWS IAM 사용자 이름
p_token | VCS OAuth Token (본 예제에서는 GitHub의 Personal Access Token을 사용)
repo_id | VCS상의 Repo 정보 (:org/:repo 포맷) 

필요한 경우, 환경 변수로 설정한 AWS 관련 정보도 변경 가능합니다.

## 참조 문서
Terraform Enterprise Provider
* [전체](https://www.terraform.io/docs/providers/tfe/index.html)
* [tfe_organization](https://www.terraform.io/docs/providers/tfe/r/organization.html)
* [tfe_oauth_client](https://www.terraform.io/docs/providers/tfe/r/oauth_client.html)

AWS Provider
* [전체](https://www.terraform.io/docs/providers/aws/index.html)
* [aws_iam_user](https://www.terraform.io/docs/providers/aws/r/iam_user.html)
* [aws_iam_access_key](https://www.terraform.io/docs/providers/aws/r/iam_access_key.html)