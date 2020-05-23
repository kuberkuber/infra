resource "aws_s3_bucket" "terraform-state-log" {
	bucket = "kuberkuber-terraform-state-log"
	acl = "log-delivery-write"

	tags = {
		Stage = "Common"
		Name = "terraform-state-log"
	}
}

resource "aws_s3_bucket" "terraform-state" {
  bucket = "kuberkuber-terraform-state"
  acl = "private"
  versioning {
	  enabled = true
  }

  tags = {
	  Stage = "Common"
	  Name = "terraform-state"
  }

  logging {
	  target_bucket = aws_s3_bucket.terraform-state-log.id
	  target_prefix = "log/"
  }

  lifecycle {
	  prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform-state-lock" {
  name = "kuberkuber-terraform-state-lock"
  read_capacity = 5
  write_capacity = 5
  hash_key = "LockID"

  attribute {
	  name = "LockID"
	  type = "S"
  }

  tags = {
	  Stage = "Common"
	  Name = "terraform-state-lock"
  }
}
