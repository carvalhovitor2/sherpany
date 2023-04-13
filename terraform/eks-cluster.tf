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

resource "kubernetes_namespace" "sherpany" {
  metadata {
    name = var.system
    labels = {
      team = var.system
    }
  }
}


module "ebs_csi_driver_controller" {
  source = "DrFaust92/ebs-csi-driver/kubernetes"

  ebs_csi_controller_image                   = ""
  ebs_csi_controller_role_name               = "ebs-csi-driver-controller"
  ebs_csi_controller_role_policy_name_prefix = "ebs-csi-driver-policy"
  oidc_url                                   = aws_iam_openid_connect_provider.openid_connect.url
}

resource "aws_iam_openid_connect_provider" "openid_connect" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cert.certificates.0.sha1_fingerprint]
  url             = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

