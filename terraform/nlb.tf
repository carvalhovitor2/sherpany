module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = var.system

  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true
  vpc_id                           = module.vpc.vpc_id
  subnets                          = module.vpc.public_subnets

  target_groups = [
    {
      name_prefix      = "http-"
      backend_protocol = "TCP"
      backend_port     = 30080
      target_type      = "instance"
    },
    {
      name_prefix      = "https-"
      backend_protocol = "TCP"
      backend_port     = 30443
      target_type      = "instance"
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    },
    {
      port               = 443
      protocol           = "TCP"
      target_group_index = 1
    }

  ]

  tags = {
    system    = "${var.system}"
    Terraform = "True"
  }
}

# Attach the HTTP target group to the first EKS Managed Node Group (Spot Instances)
resource "aws_autoscaling_attachment" "http_nlb_attachment_spot" {
  autoscaling_group_name = module.eks_managed_node_group_spot.node_group_autoscaling_group_names[0]
  lb_target_group_arn    = module.nlb.target_group_arns[0] # HTTP target group
}

# Attach the HTTP target group to the second EKS Managed Node Group (On-Demand Instances)
resource "aws_autoscaling_attachment" "http_nlb_attachment_on_demand" {
  autoscaling_group_name = module.eks_managed_node_group_on_demand.node_group_autoscaling_group_names[0]
  lb_target_group_arn    = module.nlb.target_group_arns[0] # HTTP target group
}

# Attach the HTTP target group to the first EKS Managed Node Group (Spot Instances)
resource "aws_autoscaling_attachment" "https_nlb_attachment_spot" {
  autoscaling_group_name = module.eks_managed_node_group_spot.node_group_autoscaling_group_names[0]
  lb_target_group_arn    = module.nlb.target_group_arns[1] # HTTP target group
}

# Attach the HTTP target group to the second EKS Managed Node Group (On-Demand Instances)
resource "aws_autoscaling_attachment" "https_nlb_attachment_on_demand" {
  autoscaling_group_name = module.eks_managed_node_group_on_demand.node_group_autoscaling_group_names[0]
  lb_target_group_arn    = module.nlb.target_group_arns[1] # HTTP target group
}

