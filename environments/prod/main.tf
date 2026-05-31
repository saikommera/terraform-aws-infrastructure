terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "my-terraform-state-prod"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = "prod"
      ManagedBy   = "terraform"
      CostCenter  = "platform-engineering"
      Owner       = "sre-team"
    }
  }
}

module "vpc" {
  source = "../../modules/vpc"

  env             = "prod"
  vpc_cidr        = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  tags            = local.common_tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name    = "prod-eks-cluster"
  cluster_version = "1.29"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids

  node_groups = {
    general = {
      desired_capacity = 3
      min_capacity     = 2
      max_capacity     = 15
      instance_types   = ["m5.xlarge"]
      labels           = { role = "general" }
    }
    spot = {
      desired_capacity = 2
      min_capacity     = 0
      max_capacity     = 10
      instance_types   = ["m5.large", "m5a.large", "m4.large"]
      labels           = { role = "spot" }
    }
  }

  tags = local.common_tags
}

module "tfstate_bucket" {
  source = "../../modules/s3"

  bucket_name        = "my-terraform-state-prod"
  versioning_enabled = true
  kms_key_arn        = ""
  tags               = local.common_tags
}

locals {
  common_tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
