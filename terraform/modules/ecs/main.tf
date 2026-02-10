# create task definition
resource "aws_ecs_task_definition" "ecsv2" {
  family                   = "ecsv2"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 2048
  memory                   = 4096
  execution_role_arn       = var.ecstaskexecutionrole
  task_role_arn            = var.ecstaskrole
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.image_arn
      essential = true
      "environment" : [
        { "name" : "TABLE_NAME", "value" : "ecsv2table" }
      ],
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/ecsv2"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
          awslogs-create-group  = "true"
        },
      }
    },
  ])
  runtime_platform {
    operating_system_family = var.operating_system_family
    cpu_architecture        = var.cpu_architecture
  }
}

resource "aws_ecs_cluster" "ecsv2_cluster" {
  name = "ecsv2cluster"

  setting {
    name  = "containerInsights"
    value = "enhanced"
  }
}
resource "aws_ecs_service" "ecsv2_Service" {
  name                = "ecsv2service"
  cluster             = aws_ecs_cluster.ecsv2_cluster.id
  task_definition     = aws_ecs_task_definition.ecsv2.arn
  scheduling_strategy = "REPLICA"
  desired_count       = 1
  launch_type         = "FARGATE"
  depends_on          = [var.ecstaskrole, var.ecstaskexecutionrole]

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    security_groups = var.ecs_sg[*]
    subnets         = var.aws_subnet_private[*]
  }

  load_balancer {
    target_group_arn = var.blue_lb_arn
    container_name   = "ecsv2container"
    container_port   = 8080
  }

  # this is for signal interupt when doing ctrl c , to rollback users to old working app
  sigint_rollback       = true
  wait_for_steady_state = true

}