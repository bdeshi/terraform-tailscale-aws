locals {

  tailscale_auth_token = base64encode("${var.tailscale_api_key}:")

  # list of cidr routes: cidrs of selected vpc + additional cidrs if defined
  tailscale_routes = var.advertise_routes ? concat(
    data.aws_vpc.selected.cidr_block_associations[*].cidr_block,
    length(var.additional_routes) > 0 ? var.additional_routes : []
  ) : []

  # list of vpc dns servers: each vpc cidr base + 2 & fallback_nameservers if defined
  tailscale_nameservers = var.advertise_nameservers ? concat(
    [for cidr_block in data.aws_vpc.selected.cidr_block_associations : cidrhost(cidr_block.cidr_block, 2)],
    length(var.fallback_nameservers) > 0 ? var.fallback_nameservers : []
  ) : []

}
