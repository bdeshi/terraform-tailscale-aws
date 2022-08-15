output "relay_auth_key" {
  value       = "${tailscale_tailnet_key.relay_auth.id} | expires: ${jsondecode(data.http.relay_auth_key_response.response_body).expires}"
  description = "tailscale relay auth key"
}

output "forwarded_routes" {
  value       = join(", ", local.tailscale_routes)
  description = "forwarded routes"
}

output "forwarded_nameservers" {
  value       = join(", ", local.tailscale_nameservers)
  description = "forwarded nameservers"
}

output "vpc_detail" {
  value       = "${var.vpc_id}%{for k, v in data.aws_vpc.selected.tags}%{if k == "Name"} | ${v}%{endif}%{endfor}"
  description = "selected vpc"
}

output "subnet_detail" {
  value       = "${var.subnet_id}%{for k, v in data.aws_subnet.selected.tags}%{if k == "Name"} | ${v}%{endif}%{endfor} | ${data.aws_subnet.selected.cidr_block}"
  description = "selected subnet"
}

output "security_group_detail" {
  value       = "${aws_security_group.tailscale.id} | ${aws_security_group.tailscale.name}"
  description = "security group"
}

output "ami_detail" {
  value       = "${data.aws_ami.selected.id} | ${data.aws_ami.selected.name}"
  description = "selected ami"
}

output "ec2_detail" {
  value       = "${aws_instance.tailscale.id} | ${var.relay_instance_type}"
  description = "tailscale relay id"
}

output "ec2_ip" {
  value       = "${aws_instance.tailscale.private_ip}%{if aws_instance.tailscale.public_ip != ""}, ${aws_instance.tailscale.public_ip}%{endif}"
  description = "tailscale relay ip"
}

output "ec2_ssh" {
  value       = var.relay_key_name == null ? "" : var.relay_key_name
  description = "tailscale relay ssh"
}
