data "aws_route53_zone" "selected" {
  name         = var.aws_route53_zone_name #created in bootstrap
  private_zone = false
}

data "aws_acm_certificate" "issued" {  #created in bootstrap
  domain   = var.domain_name
  statuses = ["ISSUED"]
}

 resource "aws_route53_record" "alb_alias" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = ""
  type    = "A"
  alias {
    name                   = var.aws_lb_dnsname
    zone_id                = var.aws_lb_zone_id
    evaluate_target_health = true
  }
}









