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
  aws_acm_certificate_arn = module.route53.aws_acm_certificate_arn
}

module "ecs" {
  source                  = "./modules/ecs"
  ecstaskexecutionrole    = module.iam.ecstaskexecutionrole
  ecstaskrole             = module.iam.ecstaskrole
  ecs_sg                  = module.vpc.ecs_sg
  aws_subnet_private      = module.vpc.aws_subnet_private
  operating_system_family = var.operating_system_family
  cpu_architecture        = var.cpu_architecture
  blue_lb_arn             = module.alb.blue_lb_arn
  green_lb_arn            = module.alb.green_lb_arn
  image_arn               = var.image_arn
  container_name          = var.container_name
  region                  = var.region
  cpu = var.cpu
  memory = var.memory
}

module "iam" {
  source = "./modules/iam"
  dynamodb_arn = var.dynamodb_arn
}

module "codedeploy" {
  source = "./modules/codedeploy"

  deployment_config_name = var.deployment_config_name
  codedeployrole         = module.iam.codedeployrole
  ecsv2_cluster          = module.ecs.ecsv2_cluster
  ecsv2_Service          = module.ecs.ecsv2_Service
  aws_lb_listener        = module.alb.aws_lb_listener
  blue_lb_name           = module.alb.blue_lb_name
  green_lb_name          = module.alb.green_lb_name
}

module "route53" {
  source = "./modules/route53"

  aws_lb_dnsname = module.alb.aws_lb_dnsname
  aws_lb_zone_id = module.alb.aws_lb_zone_id
  aws_route53_zone_name = var.aws_route53_zone_name
  domain_name = var.domain_name
}

module "waf" {
  source = "./modules/waf"
  alb_arn = module.alb.alb_arn
  aws_cloudwatch_log_group_name = var.aws_cloudwatch_log_group_name
  retention_in_days = var.retention_in_days
  aggregate_key_type = var.aggregate_key_type
  scope = var.scope
  limit = var.limit
  evaluation_window_sec = var.evaluation_window_sec
  metric_name = var.metric_name
}