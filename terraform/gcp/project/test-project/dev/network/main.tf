################################################################################
# VPC Module
################################################################################

module "vpc" {
    source = "../../../../module/network/"
    network_name = "test-${var.environment}-vpc"
    project_id = var.project_id
    region = var.region

    subnets = {
        public_subnet = {
            subnet_name = "test-${var.environment}-sbn-public"
            subnet_region = var.region
            subnet_ip = "10.211.0.0/18"
            subnet_private_access = "false"
        }
        private_subnet = {
            subnet_name = "test-${var.environment}-sbn-private"
            subnet_region = var.region
            subnet_ip = "10.211.64.0/18"
            subnet_private_access = "true"
        }
        internal_lb_subnet = {
            subnet_name = "test-${var.environment}-sbn-internal"
            subnet_region = var.region
            subnet_ip = "10.211.128.0/18"
            subnet_private_access = "false"
            purpose = "INTERNAL_HTTPS_LOAD_BALANCER"
            role = "ACTIVE"
        }
    }
    
    routes = []
    router_name = "test-${var.environment}-router"

    # nat_ips_count = 1

    # nat_name      = "test-${var.environment}-nat"
    # nat_subnets = {
    #     private_subnet = {
    #         subnet_name = "test-${var.environment}-sbn-private"
    #         subnet_ip = "10.211.64.0/18"
    #     }
    # }
}