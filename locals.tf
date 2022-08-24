locals {

  tailscale_auth_token = base64encode("${var.tailscale_api_key}:")

  vpc_peering_connections = setunion(
    data.aws_vpc_peering_connections.requested_peerings.ids,
    data.aws_vpc_peering_connections.accepted_peerings.ids
  )

  # list of cidr routes: cidrs of selected vpc + cidr of peers + additional cidrs if defined
  tailscale_routes = var.advertise_routes ? concat(
    data.aws_vpc.selected.cidr_block_associations[*].cidr_block,
    [
      for route in data.aws_route_table.selected.routes :
      route.cidr_block if contains(
        local.vpc_peering_connections,
        route.vpc_peering_connection_id
      )
    ],
    length(var.additional_routes) > 0 ? var.additional_routes : []
  ) : []

  # list of vpc dns servers: (cidr base + 2) for vpc cidrs + fallback_nameservers if defined
  tailscale_nameservers = var.advertise_nameservers ? concat(
    [
      for cidr_block in data.aws_vpc.selected.cidr_block_associations :
      cidrhost(cidr_block.cidr_block, 2)
    ],
    length(var.fallback_nameservers) > 0 ? var.fallback_nameservers : []
  ) : []

}
