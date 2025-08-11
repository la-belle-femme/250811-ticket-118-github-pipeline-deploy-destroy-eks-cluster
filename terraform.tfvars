github_repo_name          = "250811-ticket-118-github-pipeline-deploy-destroy-eks-cluster"
aws_region                = "us-east-1"
vpc_id                    = "vpc-0b29462da246e0151"
subnet_ids                = ["subnet-08a96a34702e19938", "subnet-0c171df46bf5e3e2f", "subnet-0325b03933424daa3"]
cluster_name              = "ticket-118-github-action-eks-cluster"
cluster_version           = "1.30"
desired_size              = 2
min_size                  = 2
max_size                  = 3
instance_types            = ["t3.medium"]
key_pair_name             = "terraform-offert-letter-key"
enabled_cluster_log_types = ["api", "audit"]
github_org                = "la-belle-femme"
tags = {
  Environment = "development"
  Project     = "ticket-118"
  Owner       = "devops-team"
}