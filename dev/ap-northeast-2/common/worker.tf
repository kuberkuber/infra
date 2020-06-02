resource "aws_eks_node_group" "worker" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "worker"
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids      = aws_subnet.eks.*.id

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_worker_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_worker_AmazonEC2ContainerRegistryReadOnly,
  ]
}

locals {
  eks_worker_userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks.certificate_authority.0.data}' '${var.cluster_name}'
USERDATA
}

resource "aws_launch_configuration" "worker" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.worker.name
  image_id                    = data.aws_ami.eks-worker.id
  instance_type               = var.instance_type
  name_prefix                 = "kuberkuber"
  security_groups             = [aws_security_group.worker-sg.id]
  user_data_base64            = base64encode(local.eks_worker_userdata)

  lifecycle {
    create_before_destroy = true
  }
}
