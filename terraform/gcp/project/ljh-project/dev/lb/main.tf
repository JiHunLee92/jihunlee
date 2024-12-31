locals {
  backends = {
    for k, v in var.lbs.dev_lb.backend_services : k => merge(v, {
      health_check_id = data.terraform_remote_state.health_checks.outputs.health_checks[v.health_check_name].self_link
      target_group_id = data.terraform_remote_state.umigs.outputs.umigs[v.target_group_name].self_link
      security_policy = v.security_policy ? google_compute_security_policy.sec_from_office.self_link : null
    })
  }
}

module "lbs" {
  source = "../../../../module/lb/"

  for_each              = var.lbs
  lb_name               = each.value.lb_name
  load_balancing_scheme = each.value.load_balancing_scheme
  # backend_services = each.value.backend_services
  backend_services = local.backends

  # lb_name = {
  #   dev_lb = {
  #     lb_name = "test-dev-lb"
  #     default_service = var.default_service
  #   }
  # }

  # default_service = var.default_service
  # for_each = local.backends

  # project_id = var.project_id

  # bnd_name = each.value.bnd_name
  # protocol = each.value.protocol
  # port_name = each.value.port_name
  # health_check_id = each.value.health_check_id
  # target_group_id = each.value.target_group_id
  # security_policy = each.value.security_policy
}

# module "bnds" {
#   source = "../../../../module/lb/"
#   for_each = local.backends

#   project_id = var.project_id

#   bnd_name = each.value.bnd_name
#   protocol = each.value.protocol
#   port_name = each.value.port_name
#   health_check_id = each.value.health_check_id
#   target_group_id = each.value.target_group_id
#   security_policy = each.value.security_policy

#   # lb_name = "test-dev-lb"
#   # default_service = self["bnd_docker"]
# }

# module "lbs" {
#   source = "../../../../module/lb/"

#   lb_name = "test-dev-lb"
#   default_service = module.bnds["bnd_docker"].self_link
#   # for_each = local.backends

#   # project_id = var.project_id

#   # bnd_name = each.value.bnd_name
#   # protocol = each.value.protocol
#   # port_name = each.value.port_name
#   # health_check_id = each.value.health_check_id
#   # target_group_id = each.value.target_group_id
#   # security_policy = each.value.security_policy
# }