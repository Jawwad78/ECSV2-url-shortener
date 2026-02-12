# locals {
#   dynamo_secret = jsondecode(data.aws_secretsmanager_secret_version.dynamosecret.secret_string)

#   dynamo_secret_list = [
#     for name, value in local.dynamo_secret : {
#       name  = name
#       value = value
#     }
#   ]
# }

# locals {
#   dynamo_secret_definition = templatefile("${path.module}/definitions/template.json", {
#     environment = local.dynamo_secret_list
#   })
# }