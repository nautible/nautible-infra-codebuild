provider "aws" {
  region = var.region
}

terraform {
  # fix folloing value
  backend "s3" {
    bucket  = "nautible-aws-codebuild-dev-tf-ap-northeast-1"
    region  = "ap-northeast-1"
    key     = "nautible-aws-codebuild-dev-tfstate"
    encrypt = true
    # if you don't need to dynamodb tfstate lock, comment out this line.
    dynamodb_table = "nautible-aws-codebuild-dev-tfstate-lock"
  }
}

module "nautible_aws_codebuild" {
  source                                 = "../../"
  pjname                                 = var.pjname
  region                                 = var.region
  vpc_id                                 = data.terraform_remote_state.nautible_aws_platform.outputs.vpc_id
  private_subnets                        = data.terraform_remote_state.nautible_aws_platform.outputs.private_subnets
  private_subnet_arns                    = data.terraform_remote_state.nautible_aws_platform.outputs.private_subnet_arns
  eks_cluster_name                       = data.terraform_remote_state.nautible_aws_platform.outputs.eks_cluster_name
  ecr_lifecycle_image_count              = var.ecr_lifecycle_image_count
}

data "terraform_remote_state" "nautible_aws_platform" {
  backend = "s3"
  config = {
    bucket = var.nautible_aws_platform_state_bucket
    region = var.nautible_aws_platform_state_region
    key    = var.nautible_aws_platform_state_key
  }
}
