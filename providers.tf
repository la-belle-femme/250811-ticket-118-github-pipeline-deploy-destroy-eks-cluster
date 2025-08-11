terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  # Optional: Configure remote backend for state management
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket"
  #   key    = "eks-cluster/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(var.tags, {
      Environment   = "production"
      Project       = "ticket-118-eks-cluster"
      ManagedBy     = "terraform"
      Repository    = var.github_repo_name
    })
  }
}