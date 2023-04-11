resource "aws_s3_bucket" "tf-state" {
  bucket = "${var.system}-tf-state"
  tags = {
    system      = "${var.system}"
  }
}
