output "ecsv2_cluster" {
  value = aws_ecs_cluster.ecsv2_cluster.name
}

output "ecsv2_Service" {
  value = aws_ecs_service.ecsv2_Service.name
}