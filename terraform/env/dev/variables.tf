# Project name
variable "pjname" {
  default = "nautible-codebuild-dev"
}
# AWS region
variable "region" {
  default = "ap-northeast-1"
}
# nautible aws platform state bucket
variable "nautible_aws_platform_state_bucket" {
  default = "nautible-aws-platform-dev-tf-ap-northeast-1"
}
# nautible aws platform state region
variable "nautible_aws_platform_state_region" {
  default = "ap-northeast-1"
}
# nautible aws platform state key
variable "nautible_aws_platform_state_key" {
  default = "nautible-aws-platform-dev.tfstate"
}
variable "ecr_lifecycle_image_count" {
  default = 5
}
