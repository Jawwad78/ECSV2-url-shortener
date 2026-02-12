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
 #I will mention this in my alias that I will set 
output "aws_lb_dnsname" {
  value = aws_lb.alb.dns_name
}

output "aws_lb_zone_id" {
  value = aws_lb.alb.zone_id
}