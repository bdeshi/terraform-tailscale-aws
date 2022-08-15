variable "tailscale_domain" {
  type        = string
  default     = "example.net"
  description = "The domain name of the tailscale network to manage."
}

variable "tailscale_admin_users" {
  type        = list(string)
  default     = ["admin"]
  description = "usernames of the tailscale network's admins, minus the `@domain` part."
}

variable "tailscale_api_key" {
  type        = string
  default     = "tskey-XXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXX"
  sensitive   = true
  description = "The tailscale API key to use."
  validation {
    condition     = can(regex("^tskey-", var.tailscale_api_key))
    error_message = "The tailscale API key must start with `tskey-`"
  }
}

variable "relay_tag" {
  type        = string
  default     = "tag:tailscale"
  description = "The tag to use for the tailscale network's relay nodes."
  validation {
    condition     = can(regex("^tag:\\w+", var.relay_tag))
    error_message = "tailscale tags must start with `tag:` followed by a tag name."
  }
}

variable "relay_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The EC2 instance type to use for the relay server."
}

variable "relay_key_name" {
  type        = string
  default     = "default"
  description = "The name of the pre-existing key pair to use for ssh access to the relay server."
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region to use."
}

variable "vpc_id" {
  type        = string
  default     = "vpc-XXXXXXXXXXXXXXXXXXXX"
  description = "ID of the vpc to deploy tailscale relay to."
}

variable "subnet_id" {
  type        = string
  default     = "subnet-XXXXXXXXXXXXXXXXXXXX"
  description = "ID of the subnet to attach tailscale relay to."
}

variable "additional_routes" {
  type        = list(string)
  default     = []
  description = "The routes in addition to selected VPC's routes, to add to the tailscale network."
  validation {
    condition = length(var.additional_routes) == 0 ? true : alltrue([
      for route in var.additional_routes :
      regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", route)
    ])
    error_message = "routes must be in CIDR format."
  }
}

variable "fallback_nameservers" {
  type = list(string)
  # default = ["169.254.169.253", "1.1.1.1", "1.0.0.1", "8.8.8.8", "8.8.4.4"]
  default     = ["1.1.1.1", "1.0.0.1", "8.8.8.8", "8.8.4.4"]
  description = "additional nameservers to push to the tailscale network."
}

variable "advertise_nameservers" {
  type        = bool
  default     = true
  description = "Whether to advertise the tailscale network's nameservers to clients."
}

variable "advertise_routes" {
  type        = bool
  default     = true
  description = "Whether to advertise the tailscale server's subnet routes to clients."
}

variable "enable_tailscale_ssh" {
  type        = bool
  default     = true
  description = "Whether to enable ssh-over-tailscale for tailscale network nodes."
}

variable "relay_associate_public_ip" {
  type        = bool
  default     = true
  description = "Whether to associate a public IP address with the relay server."
}
