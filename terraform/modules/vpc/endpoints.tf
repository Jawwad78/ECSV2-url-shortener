resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-2.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private_route[*].id

  tags = {
    Environment = "s3 endpoint"
  }
}



resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-2.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private_route[*].id

  tags = {
    Environment = "dynamodb endpoint"
  }
}

resource "aws_vpc_endpoint" "ecrapi" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-2.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.endpoint_sg.id
  ]

  private_dns_enabled = true

}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.endpoint_sg.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecs" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-2.ecs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.endpoint_sg.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecs_agent" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-2.ecs-agent"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.endpoint_sg.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecs_telemetry" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-2.ecs-telemetry"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.endpoint_sg.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecs_cloudwtach" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-2.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.endpoint_sg.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "secrets_manager" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-2.secretsmanager"

  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.endpoint_sg.id
  ]

  private_dns_enabled = true
}