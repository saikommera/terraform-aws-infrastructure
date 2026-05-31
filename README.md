# 🏗️ Terraform AWS Infrastructure

[![Terraform](https://img.shields.io/badge/Terraform-1.6+-7B42BC?style=flat-square&logo=terraform)](https://terraform.io)
[![AWS](https://img.shields.io/badge/AWS-Multi--Account-FF9900?style=flat-square&logo=amazonaws)](https://aws.amazon.com)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

Production-grade, reusable Terraform modules for multi-account AWS infrastructure. Implements IaC best practices including remote state management, policy-as-code, and zero-drift deployments.

## 📐 Architecture

```
├── modules/
│   ├── vpc/          # VPC, subnets, route tables, NAT gateways
│   ├── eks/          # EKS cluster, node groups, IRSA
│   ├── rds/          # RDS Multi-AZ with automated backups
│   ├── iam/          # Least-privilege IAM roles and policies
│   └── s3/           # S3 buckets with versioning and lifecycle
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
└── policies/         # OPA policy-as-code checks
```

## ✨ Features

- **Multi-account** provisioning with AWS Organizations
- **Remote state** with S3 backend + DynamoDB locking
- **Policy-as-code** via Open Policy Agent (OPA)
- **Zero-drift** deployments with Terraform drift detection
- **Least-privilege IAM** following AWS security best practices
- **Tagging standards** enforced for FinOps cost allocation

## 🚀 Quick Start

```bash
git clone https://github.com/saikommera/terraform-aws-infrastructure.git
cd terraform-aws-infrastructure/environments/dev

# Initialize with remote state
terraform init \
  -backend-config="bucket=your-tfstate-bucket" \
  -backend-config="key=dev/terraform.tfstate" \
  -backend-config="region=us-east-1"

# Preview changes
terraform plan -var-file="dev.tfvars"

# Apply
terraform apply -var-file="dev.tfvars"
```

## 📦 Module Usage

```hcl
module "vpc" {
  source = "../../modules/vpc"

  env             = "prod"
  vpc_cidr        = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
    CostCenter  = "platform-engineering"
  }
}

module "eks" {
  source = "../../modules/eks"

  cluster_name    = "prod-cluster"
  cluster_version = "1.29"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids

  node_groups = {
    general = {
      desired_capacity = 3
      min_capacity     = 2
      max_capacity     = 10
      instance_types   = ["m5.xlarge"]
    }
  }
}
```

## 🔐 Security

- All S3 buckets have public access blocked by default
- RDS instances deployed in private subnets only
- IAM roles follow least-privilege principle
- Secrets managed via AWS Secrets Manager / HashiCorp Vault
- GuardDuty and Security Hub enabled via Terraform

## 📊 FinOps

- Resource tagging enforced via OPA policy
- Budget alerts configured per environment
- Right-sizing recommendations via AWS Compute Optimizer

## 🧑‍💻 Author

**Sai Babji Kommera** — Senior DevOps / SRE Engineer
[LinkedIn](https://www.linkedin.com/in/sai-babji-kommera-a3b953396/) · saibabji1@gmail.com

