provider "aws" {
  region = var.region
}

module "common" {
  source                   = "./modules/common"
  pjname                   = var.pjname
  region                        = var.region
  vpc_id                        = var.vpc_id
  private_subnet_arns           = var.private_subnet_arns
}

module "application" {
  source = "./modules/application"
  pjname                       = var.pjname
  vpc_id                       = var.vpc_id
  region                        = var.region
  nautible_app_build_bucket    = module.common.nautible_app_build_bucket
  nautible_app_pipeline_bucket = module.common.nautible_app_pipeline_bucket
  nautible_app_build_role      = module.common.nautible_app_build_role
  nautible_app_pipeline_role   = module.common.nautible_app_pipeline_role
  private_subnets              = var.private_subnets
  codebuild_security_group     = module.common.codebuild_security_group
  eks_cluster_name             = var.eks_cluster_name
  ecr_lifecycle_image_count    = var.ecr_lifecycle_image_count
}
