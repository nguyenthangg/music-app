output "ec2_instance_id" {
  value = module.ec2_module.ec2_instance_id
}

output "aws_region" {
  value = var.aws_region
}

output "repository_url" {
  description = "The URL of the created ECR repository"
  value       = module.aws_ecr_repository.music-app.repository_url
}
