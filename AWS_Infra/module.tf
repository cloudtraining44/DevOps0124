provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./VPC"

  vpc_cidr = "10.0.0.0/22"
  Name = "test"
  public_sn_cidr = "10.0.1.0/24"
  }

  module "Server" {
    source = "./Servers"

    web_sg = module.vpc.vpc_id
    public_sn = module.vpc.public_sn

    depends_on = [ module.vpc ]
}

/*
module "complete_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "complete-sg"
#  vpc_id      = data.aws_vpc.default.id

  tags = {
    Cash       = "king"
    Department = "kingdom"
  }
}*/