module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = var.cluster_name
  cidr = var.cidr_block

  azs             = ["eu-central-1a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  create_vpc             = true
  enable_nat_gateway     = true
  single_nat_gateway     = true
  enable_dns_hostnames   = true

  tags = {
    "Name" = var.cluster_name
    "env"  = var.env
    "terraform" = "true"
  }

  private_subnet_tags = {
      "Name" =   "${var.cluster_name}/PrivateSubnet"
  }

  public_subnet_tags = {
      "Name" =   "${var.cluster_name}/PublicSubnet"
  }
}