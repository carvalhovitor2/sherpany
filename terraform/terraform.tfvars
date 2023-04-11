system = "sherpany"

aws_auth_users = [
  {
    userarn  = "arn:aws:iam::437472557821:user/Vitor_Carvalho"
    username = "super"
    groups   = ["system:masters"]
  }
]
