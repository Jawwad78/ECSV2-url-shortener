resource "aws_codedeploy_app" "ecsv2codedeploy" {
  compute_platform = "ECS"
  name             = "ecsv2codedeploy"
}

resource "aws_codedeploy_deployment_group" "example" {
  app_name               = aws_codedeploy_app.ecsv2codedeploy.name
  deployment_config_name = var.deployment_config_name
  deployment_group_name  = "codedeploygroupname"
  service_role_arn       = var.codedeployrole

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  #this is for when the green is ready to take new 
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    # this is once deplpoyment is done , we should terminate old blue app
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL" #this means BEHIND an alb so that's why we done YES
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecsv2_cluster
    service_name = var.ecsv2_Service
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.aws_lb_listener]
      }

      target_group {
        name = var.blue_lb_name
      }

      target_group {
        name = var.green_lb_name
      }
    }
  }
}