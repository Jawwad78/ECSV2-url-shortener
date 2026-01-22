module "vpc" {
  source             = "./modules/vpc"
  availability_zones = var.availability_zones
  sg_80              = var.sg_80
  sg_443             = var.sg_443
}

module "alb" {
  source            = "./modules/alb"
  ssl_policy        = var.ssl_policy
  sg_80             = var.sg_80
  sg_443            = var.sg_443
  aws_subnet_public = module.vpc.aws_subnet_public
  vpc_id            = module.vpc.vpc_id
  alb_sg            = module.vpc.alb_sg
  certificate_arn = var.certificate_arn
}