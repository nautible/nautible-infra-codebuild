resource "aws_codebuild_project" "codebuild_democodebuild_manifest" {
  name          = "codebuild_democodebuild_manifest"
  description   = "democodebuild_manifest_codebuild_project"
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
      name  = "EKS_CLUSTER_NAME"
      value = var.eks_cluster_name
    }
    environment_variable {
      name  = "KUBECTL_VERSION"
      value = "1.19.10"
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