resource "aws_ecr_repository" "music-app" {
  name                 = "music-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}