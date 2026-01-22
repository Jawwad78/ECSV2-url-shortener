resource "aws_lb" "alb" {
  name               = "ecsv2-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets            = var.aws_subnet_public[*]

  enable_deletion_protection = false



  tags = {
    name = "alb-ecsv2"
  }
}
#target group 
resource "aws_lb_target_group" "blue" {
  name        = "alb-target-group-blue"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    protocol            = "http"
    path                = "/"
    timeout             = 5
    interval            = 30
  }
}

#target group 
resource "aws_lb_target_group" "green" {
  name        = "alb-target-group-green"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    protocol            = "http"
    path                = "/"
    timeout             = 5
    interval            = 30
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.sg_443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.sg_80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = var.sg_443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


