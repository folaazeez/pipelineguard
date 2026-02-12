terraform {
  backend "s3" {
    bucket         = "REPLACE_ME"
    key            = "platform-foundations/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "REPLACE_ME"
    encrypt        = true
  }
}
