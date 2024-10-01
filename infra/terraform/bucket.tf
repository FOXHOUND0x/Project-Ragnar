resource "aws_s3_bucket" "ragnar_bucket" {
    bucket = "ragnar-cli-bucket"
}

resource "aws_s3_bucket_ownership_controls" "ragnar_ownersip" {
    bucket = aws_s3_bucket.ragnar_bucket.bucket
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_acl" "ragnar_acl" {
    bucket = aws_s3_bucket.ragnar_bucket.bucket
    acl    = "private"
}

resource "aws_s3_bucket_versioning" "ragnar_versioning" {
    bucket = aws_s3_bucket.ragnar_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}