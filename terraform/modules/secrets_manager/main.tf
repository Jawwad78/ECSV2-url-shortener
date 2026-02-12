data "aws_secretsmanager_secret_version" "mailing" {
  secret_id = "dynamodb_table_name"
}