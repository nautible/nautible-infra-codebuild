
resource "aws_codepipeline" "codepipeline_democodebuild_manifest" {
  name     = "codepipeline_democodebuild_manifest"
  role_arn = var.nautible_app_pipeline_role.arn

  artifact_store {
    location = var.nautible_app_pipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        BranchName       = "master"
        RepositoryName   = aws_codecommit_repository.codecommit_democodebuild_manifest.repository_name
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.codebuild_democodebuild_manifest.name
      }
    }
  }
}
