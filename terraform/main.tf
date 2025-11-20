terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
  backend "s3" {
    bucket         = "robot-backend-state-s3-bucket"
    key            = "eks/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "robot-backend-lock-table"
    encrypt = true
  }
} 

provider "aws" {
  region = var.aws_region
}
module "vpc" {
  source = "./modules/vpc"

  cluster_name            = var.cluster_name
  vpc_cidr                = var.vpc_cidr
  availability_zones      = var.availability_zones
  private_subnet_cidrs    = var.private_subnet_cidrs
  public_subnet_cidrs     = var.public_subnet_cidrs
} 

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  node_groups     = var.node_groups
}


