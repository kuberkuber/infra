data "aws_availability_zones" "available" {}

locals {
  zone_names = [
    data.aws_availability_zone.a.name,
    data.aws_availability_zone.c.name
  ]
}

data "aws_availability_zone" "a" {
  name = "ap-northeast-2a"
}

data "aws_availability_zone" "c" {
  name = "ap-northeast-2c"
}
