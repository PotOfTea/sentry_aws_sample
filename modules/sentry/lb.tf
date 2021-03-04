resource "aws_security_group" "lb" {
  description = "Sentry"
  name        = "${var.cluster_name}-lb"
  vpc_id      = module.vpc.vpc_id

  tags = {
    "Name" = "${var.cluster_name}-lb"
    "terraform" = "true"
    "env"  = var.env
  }
}

resource "aws_security_group_rule" "egress_lb" {
  type              = "egress"
  security_group_id = aws_security_group.lb.id

  protocol    = "-1"
  from_port   = 0
  to_port     = 0
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  security_group_id = aws_security_group.lb.id

  cidr_blocks = ["0.0.0.0/0"]
  description = "http"

  protocol  = "tcp"
  from_port = 80
  to_port   = 80
}

resource "aws_elb" "ingress" {
  name = "${var.cluster_name}-elb"

  listener {
    instance_port     = 9000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:9000"
    interval            = 30
  }

  instances                   = [aws_instance.sentry.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  subnets                     = [module.vpc.public_subnets[0]]
  security_groups             = [aws_security_group.lb.id]
  
  tags = {
    "env"  = var.env
    "name" = "${var.cluster_name}-elb"
    "terraform" = "true"
  }
}
