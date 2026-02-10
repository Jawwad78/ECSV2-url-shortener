resource "aws_dynamodb_table" "tfstatelock" {
  name         = "ecsv2tfstate"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

}

resource "aws_dynamodb_table" "dynamoecsv2" {
  name         = "dynamoecsv2task"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

}