################################################################################
# Elastic Beanstalk Application
################################################################################

locals {
  application_name            = "${var.svc_test}-${var.environment}"
  application_description     = "Elastic Beanstalk application for ${var.svc_test} in the ${var.environment} environment"
  configuration_template_name = "${var.svc_test}-${var.environment}-eb-config-template"
}

resource "aws_elastic_beanstalk_application" "this" {
  name        = local.application_name
  description = local.application_description

  appversion_lifecycle {
    delete_source_from_s3 = false
    max_age_in_days       = 0
    max_count             = 25
    # service_role          = data.remote_state.iam.outputs.mystore_codebuild_role
    service_role = data.aws_iam_role.elasticbeanstalk_service_role.arn
  }
}

resource "aws_elastic_beanstalk_configuration_template" "this" {
  name                = local.configuration_template_name
  application         = local.application_name
  solution_stack_name = "64bit Amazon Linux 2023 v4.0.6 running ECS"
}

################################################################################
# Elastic Beanstalk Environment
################################################################################

module "mystore_api_elasticbeanstalk_environment" {
  source = "../../../../module/elasticbeanstalk/"

  environment_name = "${var.svc_test}-${var.environment}-api"
  application_name = aws_elastic_beanstalk_application.this.name
  template_name    = aws_elastic_beanstalk_configuration_template.this.name

  cname_prefix = "${var.svc_test}-${var.environment}-api"

  vpc_id              = data.terraform_remote_state.network.outputs.vpc_id
  private_subnets_ids = data.terraform_remote_state.network.outputs.private_subnets
  public_subnets_ids  = data.terraform_remote_state.network.outputs.public_subnets
  aws_security_group  = data.terraform_remote_state.security_group.outputs.app_sg
  iam_instance_profile = data.terraform_remote_state.iam.outputs.mystore_elasticbeanstalk_instance_profile_name

  eb_settings = var.eb_settings
}

resource "local_file" "dockerrun" {
  filename = "dockerrun/Dockerrun.aws.json"
  content  = templatefile("templates/Dockerrun.aws.json.tftpl", {
    account_id = var.account_id
    image_name = data.terraform_remote_state.ecr.outputs.test_ecr_repository_name
    region = var.region
  })
}

