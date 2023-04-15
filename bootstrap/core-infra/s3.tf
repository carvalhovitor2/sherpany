resource "aws_s3_bucket" "tf-state" {
  bucket = "${var.system}-tf-state"
  tags = {
    system      = "${var.system}"
  }
}

# To store backups
resource "aws_s3_bucket" "velero_backups" {
  bucket = "my-sherpany-velero-backups"

  tags = {
    system      = "${var.system}"
  }
}
