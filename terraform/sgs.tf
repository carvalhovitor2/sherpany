resource "aws_security_group" "worker-nodes" {
  name        = "PODs security group"
  description = "Default POD security group"
  vpc_id      = module.vpc.vpc_id

  #http requests from the lb to the ingress controller
  ingress {
    description = "30080 from LB subnet"
    from_port   = 30080
    to_port     = 30080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  #https requests from the lb to the ingress controller
  ingress {
    description = "30081 from LB subnet"
    from_port   = 30443
    to_port     = 30443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name      = "${var.system}-worker-nodes"
    Terraform = "True"
  }
}
