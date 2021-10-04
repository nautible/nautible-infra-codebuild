resource "aws_s3_bucket" "nautible_app_build_bucket" {
  bucket = "nautible-app-build-bucket"
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "nautible_app_pipeline_bucket" {
  bucket = "nautible-app-pipeline-bucket"
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "build_bucket_public_access" {
  bucket                  = aws_s3_bucket.nautible_app_build_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "pipeline_bucket_public_access" {
  bucket                  = aws_s3_bucket.nautible_app_pipeline_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}