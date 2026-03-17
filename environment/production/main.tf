provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
  environment         = "production"
}

module "security" {
  source      = "../../modules/security-groups"
  vpc_id      = module.vpc.vpc_id
  my_ip       = var.my_ip
  environment = "production"
  db_port     = 5432
}

module "bastion" {
  source      = "../../modules/ec2"
  subnet_id   = module.vpc.public_subnet_id
  sg_id       = module.security.bastion_sg_id
  environment = "production"
}

module "rds" {
  source             = "../../modules/rds"
  private_subnet_id  = module.vpc.private_subnet_id
  vpc_id             = module.vpc.vpc_id
  sg_id              = module.security.rds_sg_id
  environment        = "production"
  db_username        = var.db_username
  db_password        = var.db_password
}