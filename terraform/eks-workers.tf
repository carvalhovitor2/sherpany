# spots
module "eks_managed_node_group_spot" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

  name            = "${var.system}-spot-eks-mng"
  cluster_name    = module.eks.cluster_id
  cluster_version = "1.25"
  iam_role_arn    = aws_iam_role.eks_nodes.arn
  create_iam_role = false

  subnet_ids = module.vpc.private_subnets

  # Add required variables for cluster context
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  vpc_security_group_ids            = [module.eks.node_security_group_id, aws_security_group.worker-nodes.id]

  min_size     = 1
  max_size     = 3
  desired_size = 2

  instance_types = [
    "t3a.small",
    "t3.small",
    "t3.medium"
  ]

  capacity_type = "SPOT"

  block_device_mappings = [
    {
      device_name = "/dev/xvda"

      ebs = {
        encrypted = true
      }
    }
  ]

  tags = {
    system    = "${var.system}"
    Terraform = "true"
  }
}

# on-demand (not used but nice to be here if it was a production environment. 
module "eks_managed_node_group_on_demand" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

  name            = "${var.system}-on-demand-eks-mng"
  cluster_name    = module.eks.cluster_id
  cluster_version = "1.25"
  iam_role_arn    = aws_iam_role.eks_nodes.arn
  create_iam_role = false

  subnet_ids = module.vpc.private_subnets

  # Add required variables for cluster context
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  vpc_security_group_ids            = [module.eks.node_security_group_id, aws_security_group.worker-nodes.id]

  min_size     = 0
  max_size     = 3
  desired_size = 0

  instance_types = ["t3.small"]
  capacity_type  = "ON_DEMAND"

  block_device_mappings = [
    {
      device_name = "/dev/xvda"

      ebs = {
        encrypted = true
      }
    }
  ]

  tags = {
    system    = "${var.system}"
    Terraform = "true"
  }
}
