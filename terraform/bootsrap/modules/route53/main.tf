#I've created the hosted zone as a bootstrap because when I do it in application layer,it gives me random nameserver and then,
# I have to match my domain nameservers to my hosted zone nameservers each time and that via the aws console 

# so it's best to do via bootstrap
resource "aws_route53_zone" "primary" {
  name = var.aws_route53_zone_name
}

#create ssl certificate for this domain 

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = var.validation_method

  
 key_algorithm = var.key_algorithm

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.primary.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
}












