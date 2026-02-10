terraform {
  backend "s3" {
    bucket         = "ecsv2"
    key            = "path/to/my/key"
    region         = "eu-west-2"
    dynamodb_table = "ecsv2tfstate"

  }
}
