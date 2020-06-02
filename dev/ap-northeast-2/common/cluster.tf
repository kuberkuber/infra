resource "aws_eks_cluster" "eks" {
	name = var.cluster_name
	role_arn = aws_iam_role.eks.arn

	vpc_config {
		security_group_ids = [aws_security_group.eks.id]
		subnet_ids = aws_subnet.eks[*].id
		endpoint_public_access = true
		endpoint_private_access = true
	}

	depends_on = [
		aws_iam_role_policy_attachment.eks_cluster_EKSClusterPolicy,
		aws_iam_role_policy_attachment.eks_cluster_EKSServicePolicy,
	]
}

output "endpoint" {
	value = "${aws_eks_cluster.eks.endpoint}"
}

output "kubeconfig_certificate_authority_data"{
	value = "${aws_eks_cluster.eks.certificate_authority.0.data}"
}
