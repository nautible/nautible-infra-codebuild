resource "aws_codecommit_repository" "codecommit_democodebuild" {
  repository_name = "demo-codebuild"
  description     = "Demo Codebuild App Repository"
}

resource "aws_codecommit_repository" "codecommit_democodebuild_manifest" {
  repository_name = "demo-codebuild-manifest"
  description     = "Demo Codebuild Manifest Repository"
}
