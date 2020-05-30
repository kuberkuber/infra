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

data "template_file" "kube-config" {
	template = file("${path.module}/templates/kube_config.yaml.tpl")

	vars = {
		CERTIFICATE = aws_eks_cluster.eks.certificate_authority[0].data
		MASTER_ENDPOINT = aws_eks_cluster.eks.endpoint
		CLUSTER_NAME = "kuberkuber"
		ROLE_ARN = aws_iam_role.eks-iam.arn
	}
}

