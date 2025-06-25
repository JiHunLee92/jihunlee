################################################################################
# IAM Module
################################################################################

locals {
  ecr_arns = data.terraform_remote_state.ecr.outputs.admin_ecr_arns
}

module "ecs_task_execution_role" {
  source = "../../../../module/iam"

  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
  role_name          = "${var.name}-${var.environment}-ecs-task-execution-role"

  aws_iam_role_policy_attachment = {
    attachment_1 = {
      policy_arn = data.aws_iam_policy.ecs_task_execution_policy.arn
    }
  }

  aws_iam_role_policy = {
    policy_1 = {
      role_policy_name = "${var.name}-${var.environment}-ssm-parameterstore-policy"
      role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "ssm:GetParameters",
              "secretsmanager:GetSecretValue",
              "kms:Decrypt"
            ]
            Resource = [
              "*"
            ]
          }
        ]
      })
    }
  }

  aws_iam_instance_profile = {}

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-ecs-task-execution-role"
  }
}

module "ecs_task_role" {
  source = "../../../../module/iam"

  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
  role_name          = "${var.name}-${var.environment}-ecs-task-role"

  aws_iam_role_policy_attachment = {}

  aws_iam_role_policy = {
    policy_1 = {
      role_policy_name = "${var.name}-${var.environment}-s3-access-policy"
      role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:ListBucket",
              "s3:GetBucketLocation"
            ]
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "s3:PutObject",
              "s3:GetObjectAcl",
              "s3:GetObject",
              "s3:PutObjectTagging",
              "s3:DeleteObject",
              "s3:PutObjectAcl"
            ]
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "s3:ListAllMyBuckets"
            ]
            Resource = [
              "*"
            ]
          }
        ]
      })
    }
  }

  aws_iam_instance_profile = {}

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-ecs-task-execution-role"
  }
}

module "eks_cluster_role" {
  source = "../../../../module/iam"

  assume_role_policy = data.aws_iam_policy_document.eks_assume.json
  role_name          = "${var.name}-${var.environment}-eks-cluster-role"

  aws_iam_role_policy_attachment = {
    attachment_1 = {
      policy_arn = data.aws_iam_policy.eks_cluster_policy.arn
    },
    attachment_2 = {
      policy_arn = data.aws_iam_policy.eks_vpc_resource_controller_policy.arn
    }
  }

  aws_iam_role_policy = {
    policy_1 = {
      role_policy_name = "${var.name}-${var.environment}-eks-cluster-cloudwatch-metrics-policy"
      role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "cloudwatch:PutMetricData"
            ]
            Resource = [
              "*"
            ]
          }
        ]
      })
    },
    policy_2 = {
      role_policy_name = "${var.name}-${var.environment}-eks-cluster-elb-permissions-policy"
      role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "ec2:DescribeAccountAttributes",
              "ec2:DescribeAddresses",
              "ec2:DescribeInternetGateways"
            ]
            Resource = [
              "*"
            ]
          }
        ]
      })
    }
  }

  aws_iam_instance_profile = {}

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-eks-cluster-role"
  }
}

module "eks_node_group_role" {
  source = "../../../../module/iam"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
  role_name          = "${var.name}-${var.environment}-eks-node-group-role"

  aws_iam_role_policy_attachment = {
    attachment_1 = {
      policy_arn = data.aws_iam_policy.ec2_container_registry_poweruser_policy.arn
    },
    attachment_2 = {
      policy_arn = data.aws_iam_policy.ec2_container_registry_readonly_policy.arn
    },
    attachment_3 = {
      policy_arn = data.aws_iam_policy.eks_worker_node_policy.arn
    },
    attachment_4 = {
      policy_arn = data.aws_iam_policy.ssm_managed_instance_core_policy.arn
    },
    attachment_5 = {
      policy_arn = data.aws_iam_policy.cloud_watch_agent_server_policy.arn
    },
    attachment_6 = {
      policy_arn = data.aws_iam_policy.eks_cni_policy.arn
    }
  }

  aws_iam_role_policy = {
    policy_1 = {
      role_policy_name = "${var.name}-${var.environment}-eks-node-group-autoscaling-policy"
      role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "autoscaling:DescribeAutoScalingGroups",
              "autoscaling:DescribeAutoScalingInstances",
              "autoscaling:DescribeLaunchConfigurations",
              "autoscaling:DescribeScalingActivities",
              "autoscaling:DescribeTags",
              "ec2:DescribeInstanceTypes",
              "ec2:DescribeLaunchTemplateVersions"
            ]
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "autoscaling:SetDesiredCapacity",
              "autoscaling:TerminateInstanceInAutoScalingGroup",
              "ec2:DescribeImages",
              "ec2:GetInstanceTypesFromInstanceRequirements",
              "eks:DescribeNodegroup"
            ]
            Resource = [
              "*"
            ]
          }
        ]
      })
    },
    policy_2 = {
      role_policy_name = "${var.name}-${var.environment}-eks-node-group-lb-controller-policy"
      role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "iam:CreateServiceLinkedRole"
            ]
            Condition = {
              "StringEquals" : {
                "iam:AWSServiceName" : "elasticloadbalancing.amazonaws.com"
              }
            }
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "ec2:DescribeAccountAttributes",
              "ec2:DescribeAddresses",
              "ec2:DescribeAvailabilityZones",
              "ec2:DescribeInternetGateways",
              "ec2:DescribeVpcs",
              "ec2:DescribeVpcPeeringConnections",
              "ec2:DescribeSubnets",
              "ec2:DescribeSecurityGroups",
              "ec2:DescribeInstances",
              "ec2:DescribeNetworkInterfaces",
              "ec2:DescribeTags",
              "ec2:GetCoipPoolUsage",
              "ec2:DescribeCoipPools",
              "elasticloadbalancing:DescribeLoadBalancers",
              "elasticloadbalancing:DescribeLoadBalancerAttributes",
              "elasticloadbalancing:DescribeListeners",
              "elasticloadbalancing:DescribeListenerCertificates",
              "elasticloadbalancing:DescribeSSLPolicies",
              "elasticloadbalancing:DescribeRules",
              "elasticloadbalancing:DescribeTargetGroups",
              "elasticloadbalancing:DescribeTargetGroupAttributes",
              "elasticloadbalancing:DescribeTargetHealth",
              "elasticloadbalancing:DescribeTags"
            ]
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "cognito-idp:DescribeUserPoolClient",
              "acm:ListCertificates",
              "acm:DescribeCertificate",
              "iam:ListServerCertificates",
              "iam:GetServerCertificate",
              "waf-regional:GetWebACL",
              "waf-regional:GetWebACLForResource",
              "waf-regional:AssociateWebACL",
              "waf-regional:DisassociateWebACL",
              "wafv2:GetWebACL",
              "wafv2:GetWebACLForResource",
              "wafv2:AssociateWebACL",
              "wafv2:DisassociateWebACL",
              "shield:GetSubscriptionState",
              "shield:DescribeProtection",
              "shield:CreateProtection",
              "shield:DeleteProtection"
            ]
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "ec2:AuthorizeSecurityGroupIngress",
              "ec2:RevokeSecurityGroupIngress"
            ]
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "ec2:CreateSecurityGroup"
            ]
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "ec2:CreateTags"
            ]
            Condition = {
              "StringEquals" : {
                "ec2:CreateAction" : "CreateSecurityGroup"
              },
              "Null" : {
                "aws:RequestTag/elbv2.k8s.aws/cluster" : "false"
              }
            }
            Resource = [
              "arn:aws:ec2:*:*:security-group/*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "ec2:CreateTags",
              "ec2:DeleteTags"
            ]
            Condition = {
              "Null" : {
                "aws:RequestTag/elbv2.k8s.aws/cluster" : "true",
                "aws:ResourceTag/elbv2.k8s.aws/cluster" : "false"
              }
            }
            Resource = [
              "arn:aws:ec2:*:*:security-group/*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "ec2:AuthorizeSecurityGroupIngress",
              "ec2:RevokeSecurityGroupIngress",
              "ec2:DeleteSecurityGroup"
            ]
            Condition = {
              "Null" : {
                "aws:ResourceTag/elbv2.k8s.aws/cluster" : "false"
              }
            }
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "elasticloadbalancing:CreateLoadBalancer",
              "elasticloadbalancing:CreateTargetGroup"
            ]
            Condition = {
              "Null" : {
                "aws:RequestTag/elbv2.k8s.aws/cluster" : "false"
              }
            }
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "elasticloadbalancing:CreateListener",
              "elasticloadbalancing:DeleteListener",
              "elasticloadbalancing:CreateRule",
              "elasticloadbalancing:DeleteRule"
            ]
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "elasticloadbalancing:AddTags",
              "elasticloadbalancing:RemoveTags"
            ]
            Condition = {
              "Null" : {
                "aws:RequestTag/elbv2.k8s.aws/cluster" : "true",
                "aws:ResourceTag/elbv2.k8s.aws/cluster" : "false"
              }
            }
            Resource = [
              "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
              "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
              "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "elasticloadbalancing:AddTags",
              "elasticloadbalancing:RemoveTags"
            ]
            Resource = [
              "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
              "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
              "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
              "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "elasticloadbalancing:ModifyLoadBalancerAttributes",
              "elasticloadbalancing:SetIpAddressType",
              "elasticloadbalancing:SetSecurityGroups",
              "elasticloadbalancing:SetSubnets",
              "elasticloadbalancing:DeleteLoadBalancer",
              "elasticloadbalancing:ModifyTargetGroup",
              "elasticloadbalancing:ModifyTargetGroupAttributes",
              "elasticloadbalancing:DeleteTargetGroup"
            ]
            Condition = {
              "Null" : {
                "aws:ResourceTag/elbv2.k8s.aws/cluster" : "false"
              }
            }
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "elasticloadbalancing:AddTags"
            ]
            Condition = {
              "StringEquals" : {
                "elasticloadbalancing:CreateAction" : [
                  "CreateTargetGroup",
                  "CreateLoadBalancer"
                ]
              },
              "Null" : {
                "aws:RequestTag/elbv2.k8s.aws/cluster" : "false"
              }
            }
            Resource = [
              "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
              "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
              "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "elasticloadbalancing:RegisterTargets",
              "elasticloadbalancing:DeregisterTargets"
            ]
            Resource = [
              "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "elasticloadbalancing:SetWebAcl",
              "elasticloadbalancing:ModifyListener",
              "elasticloadbalancing:AddListenerCertificates",
              "elasticloadbalancing:RemoveListenerCertificates",
              "elasticloadbalancing:ModifyRule"
            ]
            Resource = [
              "*"
            ]
          }
        ]
      })
    },
    policy_3 = {
      role_policy_name = "${var.name}-${var.environment}-eks-node-group-ebs-policy"
      role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "ec2:CreateSnapshot",
              "ec2:AttachVolume",
              "ec2:DetachVolume",
              "ec2:ModifyVolume",
              "ec2:DescribeAvailabilityZones",
              "ec2:DescribeInstances",
              "ec2:DescribeSnapshots",
              "ec2:DescribeTags",
              "ec2:DescribeVolumes",
              "ec2:DescribeVolumesModifications"
            ]
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "ec2:CreateTags"
            ]
            Condition = {
              "StringEquals" : {
                "ec2:CreateAction" : [
                  "CreateVolume",
                  "CreateSnapshot"
                ]
              }
            }
            Resource = [
              "arn:aws:ec2:*:*:volume/*",
              "arn:aws:ec2:*:*:snapshot/*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "ec2:DeleteTags"
            ]
            Resource = [
              "arn:aws:ec2:*:*:volume/*",
              "arn:aws:ec2:*:*:snapshot/*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "ec2:CreateVolume"
            ]
            Condition = {
              "StringLike" : {
                "aws:RequestTag/ebs.csi.aws.com/cluster" : "true"
              }
            }
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "ec2:CreateVolume"
            ]
            Condition = {
              "StringLike" : {
                "aws:RequestTag/CSIVolumeName" : "*"
              }
            }
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "ec2:CreateVolume"
            ]
            Condition = {
              "StringLike" : {
                "aws:RequestTag/kubernetes.io/cluster/*" : "owned"
              }
            }
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "ec2:DeleteVolume"
            ]
            Condition = {
              "StringLike" : {
                "ec2:ResourceTag/ebs.csi.aws.com/cluster" : "true"
              }
            }
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "ec2:DeleteVolume"
            ]
            Condition = {
              "StringLike" : {
                "ec2:ResourceTag/CSIVolumeName" : "*"
              }
            }
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "ec2:DeleteVolume"
            ]
            Condition = {
              "StringLike" : {
                "ec2:ResourceTag/kubernetes.io/cluster/*" : "owned"
              }
            }
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "ec2:DeleteSnapshot"
            ]
            Condition = {
              "StringLike" : {
                "ec2:ResourceTag/CSIVolumeSnapshotName" : "*"
              }
            }
            Resource = [
              "*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "ec2:DeleteSnapshot"
            ]
            Condition = {
              "StringLike" : {
                "ec2:ResourceTag/ebs.csi.aws.com/cluster" : "true"
              }
            }
            Resource = [
              "*"
            ]
          }
        ]
      })
    }
  }

  aws_iam_instance_profile = {}

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-eks-node-group-role"
  }
}

module "codebuild_role" {
  source = "../../../../module/iam/"

  assume_role_policy = data.aws_iam_policy_document.codebuild_assume.json
  role_name          = "${var.name}-${var.environment}-codebuild-role"

  aws_iam_role_policy = {
    policy_1 = {
      role_policy_name = "${var.name}-${var.environment}-codebuild-policy"
      role_policy      = templatefile("./templates/codebuild_policy.tftpl", { ecr_arns = join("\",\"", local.ecr_arns) })
    }
  }

  aws_iam_role_policy_attachment = {
    attachment_1 = {
      policy_arn = data.aws_iam_policy.cloud_watch_agent_server_policy.arn
    }
  }

  aws_iam_instance_profile = {}

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-codebuild-role"
  }
}

# module "test_elasticbeanstalk_role" {
#   source = "../../../../module/iam/"

#   assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
#   role_name          = "${var.name}-${var.environment}-elasticbeanstalk-role"

#   aws_iam_role_policy = {
#     policy_1 = {
#       role_policy_name = "${var.name}-${var.environment}-codebuild-policy"
#       role_policy = templatefile("./templates/codebuild_policy.tftpl", { ecr_arns = join("\",\"", local.ecr_arns) })
#     }
#   }

#   environment = var.environment

#   tags = {
#     Name = "${var.name}-${var.environment}-codebuild-role"
#   }

#   aws_iam_role_policy_attachment = {
#     attachment_1 = {
#       policy_arn = data.aws_iam_policy.aws_elastic_beanstalk_multicontainer_docker.arn
#     },
#     attachment_2 = {
#       policy_arn = data.aws_iam_policy.cloud_watch_agent_server_policy.arn
#     }
#   }

#   aws_iam_instance_profile = {
#     instance_profile_1 = {
#       instance_profile_name = "${var.name}-${var.environment}-ec2-instance-profile"
#     }
#   }
# }