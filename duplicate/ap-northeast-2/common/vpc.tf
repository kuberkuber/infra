resource "aws_vpc" "cluster-vpc" {
	cidr_block = "10.0.0.0/16"
	enable_dns_hostnames = true
	enable_dns_support = true

	tags = {
		"Name" = "kuberkuber"
		"kubernetes.io/cluster/kuberkuber" = "shared"
	}
}

resource "aws_subnet" "cluster-subnet" {
	count = length(local.zone_names)

	availability_zone = local.zone_names[count.index]
	cidr_block = "10.0.${count.index}.0/24"
	vpc_id = aws_vpc.cluster-vpc.id

	tags = {
		"Name" = "kuberkuber-${count.index}"
		"kubernetes.io/cluster/kuberkuber" = "shared"
	}
}

resource "aws_route_table" "cluster" {
	vpc_id = aws_vpc.cluster-vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.cluster-gateway.id
	}
}


resource "aws_internet_gateway" "cluster-gateway" {
  vpc_id = aws_vpc.cluster-vpc.id

  tags = {
	  Name = "kuberkuber-gateway"
  }
}

