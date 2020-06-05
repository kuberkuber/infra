resource "aws_lb" "nlb" {
  name                       = "${var.cluster_name}-cluster"
  internal                   = false
  load_balancer_type         = "network"
  enable_deletion_protection = true
  subnets                    = [aws_subnet.cluster-0.id,aws_subnet.cluster-1.id]
  tags = {
    "kubernetes.io/service-name"                  = "ingress-nginx/ingress-nginx-nginx-ingress-controller"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_lb_target_group" "http" {
  name        = "${var.cluster_name}-cluster-http"
  target_type = "ip"
#   target_type = "instance"
  port        = 30080
  protocol    = "TCP"
  vpc_id      = aws_vpc.cluster.id
  health_check {
    path = "/healthz"
    port = 30200
  }
  deregistration_delay = 5
}

# resource "aws_lb_target_group" "https" {
#   name        = "${var.cluster_name}-cluster-https"
#   target_type = "instance"
#   port        = var.https_port
#   protocol    = "TCP"
#   vpc_id      = var.common_vpc_id
#   health_check {
#     path = "/healthz"
#     port = var.healthcheck_port
#   }
#   deregistration_delay = 5
# }

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.default.arn
#   port              = "443"
#   protocol          = "TLS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = data.aws_acm_certificate.alpha.arn # alpha.daangn.com

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.https.arn
#   }
# }

data "aws_instances" "worker" {
	instance_tags = {
		Name = var.cluster_name
	}
}

resource "aws_lb_target_group_attachment" "target-0" {
	target_group_arn = aws_lb_target_group.http.arn
	# target_id = data.aws_instances.worker.ids[0]			# target_type=instance
	target_id = data.aws_instances.worker.private_ips[0]	# target_type=ip
	port = 30080
}

resource "aws_lb_target_group_attachment" "target-1" {
	target_group_arn = aws_lb_target_group.http.arn
	# target_id = data.aws_instances.worker.ids[1]			# target_type=instance
	target_id = data.aws_instances.worker.private_ips[1]	# target_type=ip
	port = 30080
}

# # nlb 생성 - eip와 2개 서브넷 등록
# resource "aws_eip" "eip-0" {
# 	tags = {
# 		Name = "eip-0"
# 	}
# }

# resource "aws_eip" "eip-1" {
# 	tags = {
# 		Name = "eip-1"
# 	}
# }

# resource "aws_lb" "nlb" {
# 	name               = "cluster-nlb"
# 	load_balancer_type = "network"

# 	subnet_mapping {
# 		subnet_id = aws_subnet.cluster-0.id
# 		allocation_id = aws_eip.eip-0.id
# 	}

# 	subnet_mapping {
# 		subnet_id = aws_subnet.cluster-1.id
# 		allocation_id = aws_eip.eip-1.id
# 	}
# }

# # nlb 타겟 그룹 생성 - vpc와 protocol, port 지정
# resource "aws_lb_target_group" "nlb" {
# 	name = "cluster-nlb-target-group"
# 	port = 80
# 	protocol = "TCP"
# 	vpc_id = aws_vpc.cluster.id
# }

# # nlb 타겟 그룹에 인스턴스 등록
# data "aws_instances" "worker" {
# 	instance_tags = {
# 		Name = var.cluster_name
# 	}
# }

# resource "aws_lb_target_group_attachment" "target-0" {
# 	target_group_arn = aws_lb_target_group.nlb.arn
# 	target_id = data.aws_instances.worker.ids[0]
# 	port = 30080
# }

# resource "aws_lb_target_group_attachment" "target-1" {
# 	target_group_arn = aws_lb_target_group.nlb.arn
# 	target_id = data.aws_instances.worker.ids[1]
# 	port = 30080
# }

# # 요청을 타겟 그룹에 전달하는 로드밸런서에 대한 리스너 생성
# resource "aws_lb_listener" "nlb" {
# 	load_balancer_arn = aws_lb.nlb.arn
# 	port = 80
# 	protocol = "TCP"

# 	default_action {
# 		type = "forward"
# 		target_group_arn = aws_lb_target_group.nlb.arn
# 	}
# }

# resource "aws_lb_listener_rule" "host_based_routing" {
# 	listener_arn = aws_lb_listener.nlb.arn
# 	priority     = 99

# 	action {
# 		type             = "forward"
# 		target_group_arn = aws_lb_target_group.nlb.arn
# 	}

# 	condition {
# 		host_header {
# 			values = ["service.*.kuberkuber"]
# 		}
# 	}
# }
