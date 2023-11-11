################################################################################
# IAM Module
################################################################################

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
              "*",
            ]
          }
        ]
      })
    }
  }

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
              "*",
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
              "*",
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "s3:ListAllMyBuckets"
            ]
            Resource = [
              "*",
            ]
          }
        ]
      })
    }
  }

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-ecs-task-execution-role"
  }
}

