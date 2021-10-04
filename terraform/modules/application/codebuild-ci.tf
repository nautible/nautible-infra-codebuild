resource "aws_codebuild_project" "codebuild_democodebuild" {
  name          = "codebuild_democodebuild"
  description   = "democodebuild_codebuild_project"
  build_timeout = "5"
  service_role  = var.nautible_app_build_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = var.nautible_app_build_bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true # Docker実行用


    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = aws_ecr_repository.democodebuild.name
    }
    environment_variable {
      name  = "MANIFEST_SRC_NAME"
      value = aws_codecommit_repository.codecommit_democodebuild_manifest.repository_name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${var.nautible_app_build_bucket.id}/build-log"
    }
  }

  source {
    type            = "CODEPIPELINE"
  }

  secondary_sources {
    type            = "CODECOMMIT"
    location        = aws_codecommit_repository.codecommit_democodebuild_manifest.clone_url_http
    git_clone_depth = 1
    source_identifier = "manifest"
    #source_version = "refs/heads/master" # Unsupported (https://github.com/hashicorp/terraform-provider-aws/issues/13241)
    git_submodules_config {
      fetch_submodules = false
    }
  }

  source_version = "refs/heads/master"

  vpc_config {
    vpc_id = var.vpc_id

    subnets = [
      var.private_subnets[0],
      var.private_subnets[1],
    ]

    security_group_ids = [
      var.codebuild_security_group.security_group_id,
    ]
  }

  tags = {
    Environment = "Test"
  }
}