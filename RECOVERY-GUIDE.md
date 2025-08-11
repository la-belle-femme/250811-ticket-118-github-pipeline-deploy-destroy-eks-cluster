# Recovery Steps (if GitHub Actions fails)

## Manual Recreation Steps:
1. terraform init
2. terraform apply
3. aws eks update-kubeconfig --region us-east-1 --name ticket-118-github-action-eks-cluster

## Key Resource ARNs:
- Cluster: arn:aws:eks:us-east-1:855978188999:cluster/ticket-118-github-action-eks-cluster
- GitHub Role: arn:aws:iam::855978188999:role/ticket-118-github-action-eks-cluster-github-actions-role
- OIDC Provider: arn:aws:iam::855978188999:oidc-provider/token.actions.githubusercontent.com

## Current Settings:
- Nodes: 2 t3.medium instances
- Version: 1.30
- Region: us-east-1
