resource "aws_eks_cluster" "eks" {
	name = var.cluster_name
	role_arn = aws_iam_role.eks.arn

	vpc_config {
		security_group_ids = [aws_security_group.eks.id]
		subnet_ids = [aws_subnet.cluster-0.id, aws_subnet.cluster-1.id]
		endpoint_public_access = true
		endpoint_private_access = true
	}

	depends_on = [
		aws_iam_role_policy_attachment.eks-cluster-EKSClusterPolicy,
		aws_iam_role_policy_attachment.eks-cluster-EKSServicePolicy,
	]
}
