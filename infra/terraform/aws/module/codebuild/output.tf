################################################################################
# CodeBuild 
################################################################################

output "codebuild_name" {
  description = "The name of the codebuild project"
  value       = try(aws_codebuild_project.this.name, null)
}