# deploys a tailscale relay server EC2 instance in AWS VPC.

# module "ec2_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "~> 3.0"
#   create  = true
#   name = var.tailscale_relay_name
#   ami =
#
# }

resource "aws_instance" "tailscale" {
  ami                         = data.aws_ami.selected.id
  instance_type               = var.relay_instance_type
  associate_public_ip_address = var.relay_associate_public_ip
  key_name                    = var.relay_key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.tailscale.id]
  user_data = templatefile("${path.module}/files/relay-init.sh.tftpl", {
    routes   = local.tailscale_routes
    auth_key = tailscale_tailnet_key.relay_auth.key
  })
  tags = {
    Name = "tailscale"
  }
}

resource "aws_security_group" "tailscale" {
  name_prefix = "tailscale"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = (var.relay_key_name == null || var.relay_key_name == "") ? [] : [1]
    content {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
