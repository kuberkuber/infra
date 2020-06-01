data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks.version}-v*"]
  }

  most_recent = true
  owners      = ["amazon"] # Amazon EKS AMI Account ID
}

locals {
  eks_worker_userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks.certificate_authority.0.data}' '${aws_eks_cluster.eks.id}'
USERDATA
}

resource "aws_launch_configuration" "eks-worker" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.eks-worker.name
  image_id                    = data.aws_ami.eks-worker.id
  instance_type               = var.instance_type
  name_prefix                 = "kuberkuber"
  security_groups             = [aws_security_group.worker-sg.id]
  user_data_base64            = base64encode(local.eks_worker_userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks-worker" {
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.eks-worker.id
  max_size             = 2
  min_size             = 1
  name                 = "kuberkuber"
  vpc_zone_identifier  = aws_subnet.cluster-subnet.*.id

  tag {
    key                 = "Name"
    value               = "kuberkuber"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/kuberkuber"
    value               = "owned"
    propagate_at_launch = true
  }
}
