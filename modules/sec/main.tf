variable "app" {}
variable "env" {}
variable "vpc_id" {}

resource "aws_iam_role" "ec2_role" {
  name = "EC2_S3_Read_Only"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2-role-policy-attach" {
  role = "${aws_iam_role.ec2_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "s3-role-policy-attach" {
  role = "${aws_iam_role.ec2_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "sns-role-policy-attach" {
  role = "${aws_iam_role.ec2_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2_S3_Read_Only"
  role = "${aws_iam_role.ec2_role.name}"
}

resource "aws_security_group" "ec2sg" {
  name        = "${var.app}-EC2-SG"
  description = "SG for EC2 instances"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 7979
    to_port     = 7979
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.app}-SG-EC2-${var.env}"
    App  = "${var.app}"
    Env  = "${var.env}"
  }
}

output "ec2sg_id" {
  value = "${aws_security_group.ec2sg.id}"
}

output "ec2_instance_profile_name" {
  value = "${aws_iam_instance_profile.ec2_profile.name}"
}