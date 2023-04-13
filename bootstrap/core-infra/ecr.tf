resource "aws_ecr_repository" "sherpany" {
  name = "${var.system}-web"
}


resource "aws_ecr_repository" "sherpany-db" {
  name = "${var.system}-postgresql"
}
