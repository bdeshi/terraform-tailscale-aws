data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnet" "selected" {
  id = var.subnet_id
}


data "aws_ami" "selected" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-*"]
  }
}

data "http" "relay_auth_key_response" {
  url = "https://api.tailscale.com/api/v2/tailnet/${var.tailscale_domain}/keys/${tailscale_tailnet_key.relay_auth.id}"
  request_headers = {
    Accept        = "application/json"
    Authorization = "Basic ${local.tailscale_auth_token}"
  }
}

data "aws_route_tables" "_subnet_filtered" {
  filter {
    name   = "association.subnet-id"
    values = [var.subnet_id]
  }
}

data "aws_route_table" "selected" {
  route_table_id = (length(data.aws_route_tables._subnet_filtered.ids) > 0
    ? data.aws_route_tables._subnet_filtered.ids[0]
    : data.aws_vpc.selected.main_route_table_id
  )
}

data "aws_vpc_peering_connections" "requested_peerings" {
  filter {
    name   = "requester-vpc-info.vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "status-code"
    values = ["active"]
  }
}

data "aws_vpc_peering_connections" "accepted_peerings" {
  filter {
    name   = "accepter-vpc-info.vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "status-code"
    values = ["active"]
  }
}
