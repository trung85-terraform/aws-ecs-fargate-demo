locals {
  my_name       = "${var.prefix}-${var.env}-test-ec2"
  my_deployment = "${var.prefix}-${var.env}"
  my_key_name   = "aws-ecs-fargate-demo-testing-ec2-key"
}

# NOTE: These ec2 instances are used just for debugging purposes regarding
# connections between entities in different subnets.
# NOTE: This module assumes that there is an existing key-pair with the
# same name as used in the local.my_key_name (see above).
# NOTE: Improvement suggestion: create the key-pair dynamically and use it here.

resource "aws_eip" "nat-ec2-eip" {
  instance = "${aws_instance.nat-ec2.id}"
  vpc      = true
}

resource "aws_instance" "nat-ec2" {
  ami                    = "ami-08935252a36e25f85"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${var.nat-public_subnet_sg_id}"]
  subnet_id              = "${var.nat-public_subnet_id}"
  key_name               = "${local.my_key_name}"


  tags {
    Name        = "${local.my_name}-nat"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

resource "aws_eip" "alb-ec2-eip" {
  instance = "${aws_instance.alb-ec2.id}"
  vpc      = true
}

resource "aws_instance" "alb-ec2" {
  ami                    = "ami-08935252a36e25f85"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${var.alb-public-subnet-sg_id}"]
  subnet_id              = "${var.alb_public_subnet_ids[0]}"
  key_name               = "${local.my_key_name}"

  tags {
    Name        = "${local.my_name}-alb"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

resource "aws_eip" "ecs-ec2-eip" {
  instance = "${aws_instance.ecs-ec2.id}"
  vpc      = true
}

resource "aws_instance" "ecs-ec2" {
  ami                    = "ami-08935252a36e25f85"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${var.ecs_private_subnet_sg_id}"]
  subnet_id              = "${var.ecs_private_subnet_ids[0]}"
  key_name               = "${local.my_key_name}"

  tags {
    Name        = "${local.my_name}-ecs"
    Deployment  = "${local.my_deployment}"
    Prefix      = "${var.prefix}"
    Environment = "${var.env}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}