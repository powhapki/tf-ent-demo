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
