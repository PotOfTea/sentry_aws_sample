resource "aws_security_group" "bastion" {
  description = "Enable SSH access to the bastion host from external via SSH port"
  name        = "${var.cluster_name}-bastion-sg"
  vpc_id      = module.vpc.vpc_id

  tags = {
    "Name" = "${var.cluster_name}-bastion-sg"
    "terraform" = "true"
    "env"  = var.env
  }
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.bastion.id

  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow node SSH access"
  
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22 
}

resource "aws_security_group_rule" "master_egress" {
  type              = "egress"
  security_group_id = aws_security_group.bastion.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

}

resource "aws_instance" "bastion" {
  ami                           = data.aws_ami.ubuntu.id
  instance_type                 = "t2.micro"
  associate_public_ip_address   = true
  key_name                      = var.aws_key_name
  vpc_security_group_ids       = [aws_security_group.bastion.id]
  subnet_id                     = module.vpc.public_subnets[0]
  tags = {
    Name = "${var.cluster_name}-bastion"
    "env"  = var.env
    "terraform" = "true"
  }
}