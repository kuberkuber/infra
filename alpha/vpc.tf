resource "aws_vpc" "cluster" {
	cidr_block = "10.0.0.0/16"
	enable_dns_hostnames = true
	enable_dns_support = true

	tags = {
		"Name" = var.cluster_name
		"kubernetes.io/cluster/${var.cluster_name}" = "shared"
	}
}

resource "aws_subnet" "cluster-0" {
	availability_zone = local.zone_names[0]
	cidr_block = "10.0.0.0/24"
	vpc_id = aws_vpc.cluster.id

	tags = {
		"Name" = "${var.cluster_name}-0"
		"kubernetes.io/cluster/${var.cluster_name}" = "shared"
	}
}

resource "aws_subnet" "cluster-1" {
	availability_zone = local.zone_names[1]
	cidr_block = "10.0.1.0/24"
	vpc_id = aws_vpc.cluster.id

	tags = {
		"Name" = "${var.cluster_name}-1"
		"kubernetes.io/cluster/${var.cluster_name}" = "shared"
	}
}

resource "aws_route_table" "cluster" {
	vpc_id = aws_vpc.cluster.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.cluster.id
	}
}

resource "aws_route_table_association" "eks1" {
	route_table_id = aws_route_table.cluster.id
	subnet_id = aws_subnet.cluster-0.id
}

resource "aws_route_table_association" "eks2" {
	route_table_id = aws_route_table.cluster.id
	subnet_id = aws_subnet.cluster-1.id
}

resource "aws_internet_gateway" "cluster" {
  vpc_id = aws_vpc.cluster.id

  tags = {
	  Name = "kuberkuber-gateway"
  }
}

