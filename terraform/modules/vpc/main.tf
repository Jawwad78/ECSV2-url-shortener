resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "ecsv2"
  }
}


#create subnets
resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/26"
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 3}.0/26"
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"

  }
}

#route tables
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-igw"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-subnet-route"
  }
}

#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

#assoicate the route tables to subnets!
resource "aws_route_table_association" "public" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_route.id
}

# #creating SG's
# resource "aws_security_group" "alb_sg" {
#   name   = "alb"
#   vpc_id = aws_vpc.main.id

#    tags = {
#     Name = "alb_sg"
#   }
# }

# resource "aws_security_group_rule" "http_to_alb" {
#     type = "ingress"
#     from_port   = var.sg_80
#     to_port     = var.sg_80
#     protocol    = "tcp"
#     security_group_id = aws_security_group.alb.id
#     cidr_blocks = var.cidr_blocks
# }


# resource "aws_security_group_rule" "https_to_alb" {
#     type = "ingress"
#     from_port   = var.sg_443
#     to_port     = var.sg_443
#     protocol    = "tcp"
#     security_group_id = aws_security_group.alb.id
#     cidr_blocks = var.cidr_blocks
# }
# resource "aws_security_group_rule" "alb_to_ecs" {
#     type = "egress"
#     from_port   = 3000
#     to_port     = 3000
#     protocol    = "tcp"
#     security_group_id = aws_security_group.alb.id
#     source_security_group_id = aws_security_group.ecs_sg.id

# }


# resource "aws_security_group" "ecs_sg" {
#   name   = "ecs_sg"
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "ecs_sg"
#   }
# }

# resource "aws_security_group_rule" "ecs_to_alb" {
#   type = "ingress"
#   from_port                = 3000
#   to_port                  = 3000
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.alb.id
#   security_group_id        = aws_security_group.ecs_sg.id

#   }

# resource "aws_security_group_rule" "ecs_to_endpoints" {
#   type = "egress"
#   from_port                = 0
#   to_port                  = 0
#   protocol                 = "-1"
#   security_group_id        = aws_security_group.ecs_sg.id
#   cidr_blocks = var.cidr_blocks
#   }


# # resource "aws_security_group" "ecs_sg" {
# #   name   = "ecs_sg"
# #   vpc_id = aws_vpc.main.id


# #   ingress = {
# #     from_port       = "3000"
# #     to_port         = "3000"
# #     protocol        = "tcp"
# #     cidr_blocks     = ["0.0.0.0/0"]
# #     security_groups = aws_security_group.alb.id
# #   }

# #   }
# #   tags = {
# #     Name = "ecs_sg"
# #   }
# # }







