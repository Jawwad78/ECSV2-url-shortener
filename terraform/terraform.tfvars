sg_80  = 80
sg_443 = 443
region = "eu-west-2"

ssl_policy      = "ELBSecurityPolicy-2016-08"
certificate_arn = "arn:aws:acm:eu-west-2:726661503364:certificate/62b7aab1-2a94-4428-abaf-0ba044fe6543"

cpu_architecture        = "X86_64"
operating_system_family = "LINUX"

container_name = "ecsv2container"
image_arn      = "726661503364.dkr.ecr.eu-west-2.amazonaws.com/ecsv2:latest"

deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

memory = "3 GB"
cpu = "1 vCPU"

dynamodb_arn = "arn:aws:dynamodb:eu-west-2:726661503364:table/dynamoecsv2task"