
# resource "aws_route53_zone" "primary" {
#   name = "jawwad.org"
# }

# #create ssl certificate for this domain 

# resource "aws_acm_certificate" "cert" {
#   domain_name       = "jawwad.org"
#   validation_method = "DNS"

  
#  key_algorithm = "RSA_2048"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_record" "example" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = aws_route53_zone.primary.zone_id
# }

# #i would keep this in , but aws can take upto 2 hours of validation, so it's your choice if you want to or not, I'll just do it manually from console

# # resource "aws_acm_certificate_validation" "example" {
# #   certificate_arn         = aws_acm_certificate.cert.arn
# #   validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
# # }

