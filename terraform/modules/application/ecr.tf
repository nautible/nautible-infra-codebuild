resource "aws_ecr_repository" "democodebuild" {
  name                 = "demo_codebuild"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "democodebuild_lifecycle_policy" {
  repository = aws_ecr_repository.democodebuild.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last ${var.ecr_lifecycle_image_count} images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": ${var.ecr_lifecycle_image_count}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}