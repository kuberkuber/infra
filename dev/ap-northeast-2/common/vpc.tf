resource "aws_vpc" "cluster" {
	cidr_block = "10.0.0.0/16"

	tags = {
		"Name" = "kuberkuber"
		"kubernetes.io/cluster/kuberkuber" = "shared"
	}
}

resource "aws_subnet" "cluster_subnet" {
	count = length(local.zone_names)

	availability_zone = local.zone_names[count.index]
	cidr_block = "10.0.${count.index}.0/24"
	vpc_id = aws_vpc.cluster.id

	tags = {
		"Name" = "kuberkuber-${count.index}"
		"kubernetes.io/cluster/kuberkuber" = "shared"
	}
}
