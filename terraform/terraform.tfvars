sg_80  = 80
sg_443 = 443
region = "eu-west-2"

ssl_policy      = "ELBSecurityPolicy-2016-08"


cpu_architecture        = "X86_64"
operating_system_family = "LINUX"

container_name = "ecsv2container"
image_arn      = "726661503364.dkr.ecr.eu-west-2.amazonaws.com/bluegreen:latest"

deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

memory = "3 GB"
cpu = "1 vCPU"

dynamodb_arn = "arn:aws:dynamodb:eu-west-2:726661503364:table/dynamoecsv2task"