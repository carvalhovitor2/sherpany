module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  enable_irsa                    = false
  cluster_name                   = var.system
  cluster_version                = "1.24"
  cluster_encryption_config      = []
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.private_subnets
  control_plane_subnet_ids  = module.vpc.public_subnets #this is not ideal, it's only here because otherwise I wouldn't be able to interact with the kubernetes api in the pipelines/locally
  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  aws_auth_roles = [

    {
      rolearn  = "${aws_iam_role.eks_nodes.arn}"
      username = "${var.system}-nodes"
      groups   = ["system:nodes", "system:bootsrappers"]
    },
    {
      rolearn  = "${aws_iam_role.eks_nodes.arn}"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:nodes", "system:bootsrappers"]
    }
  ]

  aws_auth_users = var.aws_auth_users

  tags = {
    system = var.system
  }
}
