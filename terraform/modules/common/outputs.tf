output "codebuild_security_group" {
  value = module.codebuild_security_group
}
output "nautible_app_build_bucket" {
  value = aws_s3_bucket.nautible_app_build_bucket
}
output "nautible_app_pipeline_bucket" {
  value = aws_s3_bucket.nautible_app_pipeline_bucket
}

output "nautible_app_build_role" {
  value = aws_iam_role.nautible_app_build_role
}

output "nautible_app_pipeline_role" {
  value = aws_iam_role.nautible_app_pipeline_role
}