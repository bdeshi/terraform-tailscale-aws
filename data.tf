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

  # Optional request headers
  request_headers = {
    Accept        = "application/json"
    Authorization = "Basic ${local.tailscale_auth_token}"
  }
}
