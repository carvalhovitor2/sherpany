data "aws_availability_zones" "available" {}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_route53_zone" "vitorcarvalho" {
  name         = "vitorcarvalho.es."
  private_zone = false
}


# s3 backups
data "aws_s3_bucket" "velero_backups" {
  bucket = "my-sherpany-velero-backups"
}
