resource "aws_eks_cluster" "eks" {
	name = "kuberkuber"
	role_arn = aws_iam_role.eks-iam.arn

	vpc_config {
		security_group_ids = [aws_security_group.cluster-sg.id]
		subnet_ids = aws_subnet.cluster-subnet.*.id
	}

	depends_on = [
		aws_iam_role_policy_attachment.eks-cluster-EKSClusterPolicy,
		aws_iam_role_policy_attachment.eks-cluster-EKSServicePolicy,
	]
}
