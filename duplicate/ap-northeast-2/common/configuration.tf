terraform{
	required_version = "0.12.25"
	backend "s3" {
		region = "ap-northeast-2"
		bucket = "kuberkuber-terraform-state"
		key = "current/dev/ap-northeast-2/common/terraform.tfstate"
		encrypt = true
		acl = "bucket-owner-full-control"
		dynamodb_table = "kuberkuber-terraform-state-lock"
	}
}

provider "aws" {
	region = "ap-northeast-2"
	version = "2.63.0"
}
