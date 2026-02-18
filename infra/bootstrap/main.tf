provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "pipelineguard-chatgpt-fola"
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_policy" "terraform_ci" {
  name   = "terraform-ci-policy"
  policy = file("${path.module}/terraform-ci-policy.json")
}

resource "aws_iam_role_policy_attachment" "terraform_ci_attach" {
  role       = aws_iam_role.github_actions_tf.name
  policy_arn = aws_iam_policy.terraform_ci.arn
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "pipelineguard-chatgpt"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "state_bucket" {
  value = aws_s3_bucket.tf_state.bucket
}

output "lock_table" {
  value = aws_dynamodb_table.tf_lock.name
}

data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "github_actions_tf" {
  name = "github-actions-terraform"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:folaazeez/pipelineguard:*"
          }
        }
      }
    ]
  })
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions_tf.arn
}
