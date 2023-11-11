################################################################################
# IAM 
################################################################################

output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = aws_iam_role.this.arn
}

output "iam_role_name" {
  description = "Name of IAM role"
  value       = aws_iam_role.this.name
}

output "iam_role_path" {
  description = "Path of IAM role"
  value       = aws_iam_role.this.path
}

output "iam_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = aws_iam_role.this.unique_id
}