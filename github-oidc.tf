# GitHub OIDC Provider - Create new one since it doesn't exist
resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1", # GitHub's current thumbprint
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"  # Backup thumbprint
  ]

  tags = merge(var.tags, {
    Name = "github-actions-oidc"
  })
}

# IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions_role" {
  name = "${var.cluster_name}-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_actions.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo_name}:*"
          }
        }
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for GitHub Actions - EKS Management
resource "aws_iam_policy" "github_actions_eks_policy" {
  name        = "${var.cluster_name}-github-actions-eks-policy"
  description = "IAM policy for GitHub Actions to manage EKS cluster"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          # EKS Cluster permissions
          "eks:CreateCluster",
          "eks:DeleteCluster",
          "eks:DescribeCluster",
          "eks:UpdateClusterConfig",
          "eks:UpdateClusterVersion",
          "eks:TagResource",
          "eks:UntagResource",
          "eks:ListClusters",
          
          # EKS Node Group permissions
          "eks:CreateNodegroup",
          "eks:DeleteNodegroup",
          "eks:DescribeNodegroup",
          "eks:UpdateNodegroupConfig",
          "eks:UpdateNodegroupVersion",
          "eks:ListNodegroups",
          
          # EKS Add-ons permissions
          "eks:CreateAddon",
          "eks:DeleteAddon",
          "eks:DescribeAddon",
          "eks:UpdateAddon",
          "eks:ListAddons",
          "eks:DescribeAddonVersions",
          
          # CloudWatch Logs permissions for EKS
          "logs:CreateLogGroup",
          "logs:DescribeLogGroups",
          "logs:DeleteLogGroup",
          "logs:PutRetentionPolicy",
          "logs:TagLogGroup",
          
          # EC2 permissions for EKS
          "ec2:DescribeVpcs",
          "ec2:DescribeVpcAttribute",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeRouteTables",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeInternetGateways",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:CreateTags",
          "ec2:DescribeTags",
          "ec2:DeleteTags",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateLaunchTemplateVersion",
          "ec2:ModifyLaunchTemplate",
          "ec2:DeleteLaunchTemplate",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:DescribeInstances",
          
          # Auto Scaling permissions
          "autoscaling:CreateAutoScalingGroup",
          "autoscaling:DeleteAutoScalingGroup",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:UpdateAutoScalingGroup",
          "autoscaling:CreateLaunchConfiguration",
          "autoscaling:DeleteLaunchConfiguration",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:CreateOrUpdateTags",
          "autoscaling:DeleteTags",
          "autoscaling:DescribeTags"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for GitHub Actions - IAM Management
resource "aws_iam_policy" "github_actions_iam_policy" {
  name        = "${var.cluster_name}-github-actions-iam-policy"
  description = "IAM policy for GitHub Actions to manage IAM resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          # IAM Role permissions
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:ListRoles",
          "iam:UpdateRole",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:ListRoleTags",
          "iam:PassRole",
          
          # IAM Policy permissions
          "iam:CreatePolicy",
          "iam:DeletePolicy",
          "iam:GetPolicy",
          "iam:ListPolicies",
          "iam:ListPolicyVersions",
          "iam:GetPolicyVersion",
          "iam:CreatePolicyVersion",
          "iam:DeletePolicyVersion",
          "iam:TagPolicy",
          "iam:UntagPolicy",
          
          # IAM Role Policy Attachment permissions
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:ListRolePolicies",
          "iam:GetRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          
          # IAM Instance Profile permissions (for node groups)
          "iam:CreateInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:GetInstanceProfile",
          "iam:ListInstanceProfiles",
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:TagInstanceProfile",
          "iam:UntagInstanceProfile",
          
          # IAM OIDC Provider permissions
          "iam:CreateOpenIDConnectProvider",
          "iam:DeleteOpenIDConnectProvider",
          "iam:GetOpenIDConnectProvider",
          "iam:ListOpenIDConnectProviders",
          "iam:TagOpenIDConnectProvider",
          "iam:UntagOpenIDConnectProvider",
          "iam:UpdateOpenIDConnectProviderThumbprint"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

# Remove this entire policy since we're not using remote state
# resource "aws_iam_policy" "github_actions_terraform_policy" {
#   name        = "${var.cluster_name}-github-actions-terraform-policy"
#   description = "IAM policy for GitHub Actions to manage Terraform state"
#   
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           # S3 permissions for state management
#           "s3:GetObject",
#           "s3:PutObject",
#           "s3:DeleteObject",
#           "s3:ListBucket",
#           "s3:GetObjectVersion",
#           "s3:GetBucketVersioning",
#           "s3:PutBucketVersioning"
#         ]
#         Resource = [
#           "arn:aws:s3:::*terraform-state*",
#           "arn:aws:s3:::*terraform-state*/*"
#         ]
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           # DynamoDB permissions for state locking
#           "dynamodb:GetItem",
#           "dynamodb:PutItem",
#           "dynamodb:DeleteItem",
#           "dynamodb:DescribeTable"
#         ]
#         Resource = "arn:aws:dynamodb:*:*:table/*terraform-state-lock*"
#       }
#     ]
#   })
# 
#   tags = var.tags
# }

# Attach policies to the GitHub Actions role
resource "aws_iam_role_policy_attachment" "github_actions_eks_policy_attachment" {
  policy_arn = aws_iam_policy.github_actions_eks_policy.arn
  role       = aws_iam_role.github_actions_role.name
}

resource "aws_iam_role_policy_attachment" "github_actions_iam_policy_attachment" {
  policy_arn = aws_iam_policy.github_actions_iam_policy.arn
  role       = aws_iam_role.github_actions_role.name
}

# Remove this attachment since we're not creating the terraform policy
# resource "aws_iam_role_policy_attachment" "github_actions_terraform_policy_attachment" {
#   policy_arn = aws_iam_policy.github_actions_terraform_policy.arn
#   role       = aws_iam_role.github_actions_role.name
# }