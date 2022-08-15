# configures tailscale network to use the relay server.

resource "tailscale_acl" "default" {
  acl = templatefile("${path.module}/files/acl.hujson.tftpl", {
    admins     = var.tailscale_admin_users
    domain     = var.tailscale_domain
    tag        = var.relay_tag
    routes     = local.tailscale_routes
    enable_ssh = var.enable_tailscale_ssh
  })
}

resource "tailscale_tailnet_key" "relay_auth" {
  preauthorized = true
  reusable      = true
  ephemeral     = false
  tags          = [var.relay_tag]
  depends_on    = [tailscale_acl.default]
}

resource "tailscale_dns_nameservers" "vpc_dns" {
  count       = var.advertise_nameservers ? 1 : 0
  nameservers = local.tailscale_nameservers
}
