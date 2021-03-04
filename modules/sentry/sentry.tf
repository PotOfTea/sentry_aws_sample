
resource "aws_security_group" "sentry" {
  description = "Sentry"
  name        = "${var.cluster_name}-sentry"
  vpc_id      = module.vpc.vpc_id

  tags = {
    env  = var.env
    name = "${var.cluster_name}-sentry"
  }
}


resource "aws_security_group_rule" "sentry_bastion_ssh" {
  type                     = "ingress"
  description              = "sentry"
  security_group_id        =  aws_security_group.sentry.id
  source_security_group_id =  aws_security_group.bastion.id

  protocol  = "tcp"
  from_port = 22
  to_port   = 22
}

resource "aws_security_group_rule" "sentry_lb" {
  type                     = "ingress"
  description              = "http_lb"
  security_group_id        =  aws_security_group.sentry.id
  source_security_group_id =  aws_security_group.lb.id

  protocol  = "tcp"
  from_port = 9000
  to_port   = 9000
}

resource "aws_security_group_rule" "egress_sentry" {
  type                     = "egress"
  security_group_id        =  aws_security_group.sentry.id

  protocol  = "-1"
  from_port = 0
  to_port   = 0
  cidr_blocks = ["0.0.0.0/0"]
}


data "template_file" "init_script" {
  template = "${file("${path.module}/scripts/init-sentry.sh.tpl")}"
  vars = {
    sentry_email = var.sentry_email
    sentry_pass  = var.sentry_pass
  }
}



resource "aws_instance" "sentry" {
  ami                           = data.aws_ami.ubuntu.id
  instance_type                 = "t2.medium"
  associate_public_ip_address   = true
  key_name                      = var.aws_key_name
  vpc_security_group_ids       = [aws_security_group.sentry.id]
  subnet_id                     = module.vpc.private_subnets[0]
  user_data                     = data.template_file.init_script.rendered
  
  tags = {
    "env"  = var.env
    "name" = "${var.cluster_name}-sentry"
    "terraform" = "true"
  }
}


