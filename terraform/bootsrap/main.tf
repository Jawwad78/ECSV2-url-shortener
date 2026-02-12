module "ecr" {
  source = "./modules/ecr"
}

module "s3" {
  source = "./modules/s3"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

# module "route53" {
#   source = "./modules/route53"
# }