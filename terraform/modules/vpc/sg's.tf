# i used a security group rule as the sgs must refernece each other BUT also must be created before hand so 
# using this fixes that problem 

#creating SG's
resource "aws_security_group" "alb" {
  name   = "alb"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "alb_sg"
  }
}

resource "aws_security_group_rule" "http_to_alb" {
  type              = "ingress"
  from_port         = var.sg_80
  to_port           = var.sg_80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = var.cidr_blocks
}


resource "aws_security_group_rule" "https_to_alb" {
  type              = "ingress"
  from_port         = var.sg_443
  to_port           = var.sg_443
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = var.cidr_blocks
}
resource "aws_security_group_rule" "alb_to_ecs" {
  type                     = "egress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = aws_security_group.ecs_sg.id

}


resource "aws_security_group" "ecs_sg" {
  name   = "ecs_sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ecs_sg"
  }
}

resource "aws_security_group_rule" "ecs_to_alb" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.ecs_sg.id

}

resource "aws_security_group_rule" "ecs_to_endpoints" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ecs_sg.id
  cidr_blocks       = var.cidr_blocks
}
