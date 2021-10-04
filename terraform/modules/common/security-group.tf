module "codebuild_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.2.0"

  name   = "${var.pjname}-codebuild-sg"
  vpc_id = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name = "${var.pjname}-codebuild-sg"
  }
}
