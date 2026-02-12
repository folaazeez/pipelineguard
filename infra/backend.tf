terraform {
  backend "s3" {
    bucket         = "pipelineguard-chatgpt-fola"
    key            = "platform-foundations/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "pipelineguard-chatgpt"
    encrypt        = true
  }
}
