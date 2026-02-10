resource "aws_s3_bucket" "ecsv2bucket" {
  bucket = "ecsv2"

  tags = {
    Name = "My bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.ecsv2bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.ecsv2bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.ecsv2bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "appspec" {
  bucket = "appspececs"

  tags = {
    Name = "appspec"
  }
}

resource "aws_s3_bucket_ownership_controls" "example2" {
  bucket = aws_s3_bucket.appspec.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example2" {
  bucket = aws_s3_bucket.appspec.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_versioning" "versioning_example2" {
  bucket = aws_s3_bucket.appspec.id
  versioning_configuration {
    status = "Enabled"
  }
}

