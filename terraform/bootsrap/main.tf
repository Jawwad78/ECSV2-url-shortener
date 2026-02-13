module "ecr" {
  source = "./modules/ecr"
}

module "s3" {
  source = "./modules/s3"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "route53" {
  source = "./modules/route53"
  domain_name = var.domain_name
  aws_route53_zone_name = var.aws_route53_zone_name
  key_algorithm = var.key_algorithm
  validation_method = var.validation_method
}