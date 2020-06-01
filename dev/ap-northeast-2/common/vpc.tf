resource "aws_vpc" "eks" {
	cidr_block = "10.0.0.0/16"

	tags = {
		"Name" = "kuberkuber"
		"kubernetes.io/cluster/${var.cluster_name}" = "shared"
	}
}

resource "aws_subnet" "eks" {
	count = length(local.zone_names)

	availability_zone = local.zone_names[count.index]
	cidr_block = "10.0.${count.index}.0/24"
	vpc_id = aws_vpc.eks.id

	tags = {
		"Name" = "${var.cluster_name}-${count.index}"
		"kubernetes.io/cluster/${var.cluster_name}" = "shared"
	}
}
