resource "aws_eks_cluster" "eks" {
	name = "kuberkuber"
	role_arn = aws_iam_role.eks-iam.arn

	vpc_config {
		security_group_ids = [aws_security_group.eks-sg.id]
		subnet_ids = aws_subnet.cluster-subnet.*.id
		endpoint_public_access = true
		endpoint_private_access = true
	}

	depends_on = [
		aws_iam_role_policy_attachment.eks-cluster-EKSClusterPolicy,
		aws_iam_role_policy_attachment.eks-cluster-EKSServicePolicy,
	]
}
