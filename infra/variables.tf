variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "policy_gate_image" {
  type        = string
  description = "Container image URI for policy-gate (including tag)"
}
