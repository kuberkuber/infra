resource "aws_iam_role" "eks" {
	name = "${var.cluster_name}-eks"

	assume_role_policy = <<POLICY
{
"Version": "2012-10-17",
"Statement": [
	{
	"Action": "sts:AssumeRole",
	"Principal": {
		"Service": "eks.amazonaws.com"
	},
	"Effect": "Allow",
	"Sid": ""
	}
]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster_EKSClusterPolicy"{
	policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
	role = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_EKSServicePolicy" {
	policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
	role = aws_iam_role.eks.name
}
