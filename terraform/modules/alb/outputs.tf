output "blue_lb_name" {
  value = aws_lb_target_group.blue.name
}

output "green_lb_name" {
  value = aws_lb_target_group.green.name
}

output "blue_lb_arn" {
  value = aws_lb_target_group.blue.arn
}

output "green_lb_arn" {
  value = aws_lb_target_group.green.arn
}
output "aws_lb_listener" {
  value = aws_lb_listener.https_listener.arn
}