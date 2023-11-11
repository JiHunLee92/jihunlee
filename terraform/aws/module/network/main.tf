locals {
  len_public_subnets  = max(length(var.public_subnets))
  len_private_subnets = max(length(var.private_subnets))

  max_subnet_length = max(
    local.len_public_subnets,
    local.len_private_subnets,
  )

  vpc_id = aws_vpc.this[0].id

  create_vpc = var.create_vpc
}

################################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  count = local.create_vpc ? 1 : 0

  cidr_block = var.vpc_cidr

  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name        = "${var.name}-${var.environment}-vpc"
    Terraform   = var.terraform
    Environment = var.environment
  }
}

################################################################################
# Publiс Subnets
################################################################################

locals {
  create_public_subnets = local.create_vpc && local.len_public_subnets > 0
}

resource "aws_subnet" "public" {
  count = local.create_public_subnets && (!var.one_nat_gateway_per_az || local.len_public_subnets >= length(var.azs)) ? local.len_public_subnets : 0

  vpc_id            = local.vpc_id
  availability_zone = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  cidr_block        = element(concat(var.public_subnets, [""]), count.index)

  tags = {
    Name        = format("${var.name}-${var.environment}-sbn-${var.public_subnet_suffix}-%s", substr(element(var.azs, count.index), -2, 2))
    Terraform   = var.terraform
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  count = local.create_public_subnets ? 1 : 0

  vpc_id = local.vpc_id

  tags = {
    Name        = "${var.name}-${var.environment}-rot-${var.public_subnet_suffix}"
    Terraform   = var.terraform
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  count = local.create_public_subnets ? local.len_public_subnets : 0

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route" "public_internet_gateway" {
  count = local.create_public_subnets && var.create_igw ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

################################################################################
# Private Subnets
################################################################################

locals {
  create_private_subnets = local.create_vpc && local.len_private_subnets > 0
}

resource "aws_subnet" "private" {
  count = local.create_private_subnets ? local.len_private_subnets : 0

  vpc_id            = local.vpc_id
  availability_zone = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  cidr_block        = element(concat(var.private_subnets, [""]), count.index)

  tags = {
    Name        = format("${var.name}-${var.environment}-sbn-${var.private_subnet_suffix}-%s", substr(element(var.azs, count.index), -2, 2))
    Terraform   = var.terraform
    Environment = var.environment
  }
}

# There are as many routing tables as the number of NAT gateways
resource "aws_route_table" "private" {
  count = local.create_private_subnets && local.max_subnet_length > 0 ? local.nat_gateway_count : 0

  vpc_id = local.vpc_id

  tags = {
    Name = var.single_nat_gateway ? "${var.name}-${var.environment}-rot-${var.private_subnet_suffix}" : format(
      "${var.name}-${var.environment}-rot-${var.private_subnet_suffix}-%s",
      element(var.azs, count.index),
    )
    Terraform   = var.terraform
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private" {
  count = local.create_private_subnets ? local.len_private_subnets : 0

  subnet_id = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(
    aws_route_table.private[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

resource "aws_route" "private_nat_gateway" {
  count = local.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  route_table_id         = element(aws_route_table.private[*].id, count.index)
  destination_cidr_block = var.nat_gateway_destination_cidr_block
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  count = local.create_public_subnets && var.create_igw ? 1 : 0

  vpc_id = local.vpc_id

  tags = {
    Name        = "${var.name}-${var.environment}-igw"
    Terraform   = var.terraform
    Environment = var.environment
  }
}

################################################################################
# NAT Gateway
################################################################################

locals {
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length
  nat_gateway_ips   = var.reuse_nat_ips ? var.external_nat_ip_ids : try(aws_eip.nat[*].id, [])
}

resource "aws_eip" "nat" {
  count = local.create_vpc && var.enable_nat_gateway && !var.reuse_nat_ips ? local.nat_gateway_count : 0

  domain = "vpc"

  tags = {
    Name = format(
      "${var.name}-${var.environment}-eip-%s",
      substr(element(var.azs, var.single_nat_gateway ? 0 : count.index), -2, 2),
    )
    Terraform   = var.terraform
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "this" {
  count = local.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  allocation_id = element(
    local.nat_gateway_ips,
    var.single_nat_gateway ? 0 : count.index,
  )
  subnet_id = element(
    aws_subnet.public[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )

  tags = {
    Name = format(
      "${var.name}-${var.environment}-ngw-%s",
      substr(element(var.azs, var.single_nat_gateway ? 0 : count.index), -2, 2),
    )
    Terraform   = var.terraform
    Environment = var.environment
  }
  depends_on = [aws_internet_gateway.this]
}

################################################################################
# Endpoint(s)
################################################################################

# data "aws_vpc_endpoint_service" "this" {
#   for_each = local.endpoints

#   service      = try(each.value.service, null)
#   service_name = try(each.value.service_name, null)

#   filter {
#     name   = "service-type"
#     values = [try(each.value.service_type, "Interface")]
#   }
# }

# resource "aws_vpc_endpoint" "this" {
#   for_each = local.endpoints

#   vpc_id            = var.vpc_id
#   service_name      = data.aws_vpc_endpoint_service.this[each.key].service_name
#   vpc_endpoint_type = try(each.value.service_type, "Interface")

#   security_group_ids  = try(each.value.service_type, "Interface") == "Interface" ? length(distinct(concat(local.security_group_ids, lookup(each.value, "security_group_ids", [])))) > 0 ? distinct(concat(local.security_group_ids, lookup(each.value, "security_group_ids", []))) : null : null
#   subnet_ids          = try(each.value.service_type, "Interface") == "Interface" ? distinct(concat(var.subnet_ids, lookup(each.value, "subnet_ids", []))) : null
#   route_table_ids     = try(each.value.service_type, "Interface") == "Gateway" ? lookup(each.value, "route_table_ids", null) : null
#   policy              = try(each.value.policy, null)
#   private_dns_enabled = try(each.value.service_type, "Interface") == "Interface" ? try(each.value.private_dns_enabled, null) : null

#   tags = merge(var.tags, try(each.value.tags, {}))

#   timeouts {
#     create = try(var.timeouts.create, "10m")
#     update = try(var.timeouts.update, "10m")
#     delete = try(var.timeouts.delete, "10m")
#   }
# }