variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "app" {
  type    = "string"
  default = "Xonotic"
}
variable "env" {
  type    = "string"
  default = "PROD"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module "vpc" {
  source = "../modules/vpc"
  app = "${var.app}"
  env = "${var.env}"
}

module "s3" {
  source = "../modules/s3"
  app = "${var.app}"
  env = "${var.env}"
}

module "sec" {
  source = "../modules/sec"
  app = "${var.app}"
  env = "${var.env}"
  vpc_id = "${module.vpc.vpc_id}"
}

module "ec2" {
  source = "../modules/ec2"
  app = "${var.app}"
  env = "${var.env}"
  ec2sg_id = "${module.sec.ec2sg_id}"
  snAPP1_id = "${module.vpc.snAPP1_id}"
  ec2_instance_profile_name = "${module.sec.ec2_instance_profile_name}"
}