################################################################################
# EC2 
################################################################################

output "gateway_ec2_id" {
  value = module.gateway_ec2.instance_id
}