variable "app" {}
variable "env" {}
variable "ec2sg_id" {}
variable "snAPP1_id" {}
variable "ec2_instance_profile_name" {}

data "template_file" "user_data" {
  template = "${file("../files/user_data.tpl")}"
}

resource "aws_instance" "web" {
  ami = "ami-0ff8a91507f77f867"
  instance_type = "t3.medium"
  user_data = "${data.template_file.user_data.rendered}"
  vpc_security_group_ids = ["${var.ec2sg_id}"]
  subnet_id = "${var.snAPP1_id}"
  key_name = "letmein"
  iam_instance_profile = "${var.ec2_instance_profile_name}"

  tags {
    App = "${var.app}"
    Env = "${var.env}"
  }
}