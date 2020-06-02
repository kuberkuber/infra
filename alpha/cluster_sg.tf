resource "aws_security_group" "eks" {
	name = "kuberkuber-eks"
	description = "Cluster communication with worker nodes"
	vpc_id = aws_vpc.cluster.id

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "kuberkuber-eks"
	}
}

resource "aws_security_group_rule" "eks_cluster_ingress_node_https" {
  description              = "Allow pods running extension API servers on port 443 to receive communication from cluster control plane."
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks.id
  source_security_group_id = aws_security_group.worker.id
  to_port                  = 443
  type                     = "ingress"
}

variable "instance_type" {
  default = "t3.medium"
  type    = string
}
