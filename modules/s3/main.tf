variable "app" {}
variable "env" {}

resource "aws_s3_bucket" "bucket" {
  bucket = "xonotic-filez"
  acl = "private"

  tags {
    App = "${var.app}"
    Env = "${var.env}"
  }
}

resource "aws_s3_bucket_object" "server_hcl" {
    bucket = "${aws_s3_bucket.bucket.id}"
    acl    = "private"
    key    = "server.cfg"
    source = "../files/server.cfg"
}