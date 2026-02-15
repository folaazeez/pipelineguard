resource "aws_ecr_repository" "policy_gate" {
  name                 = "policy-gate"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repo_url" {
  value = aws_ecr_repository.policy_gate.repository_url
}
