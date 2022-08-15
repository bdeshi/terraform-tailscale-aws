terraform {
  required_version = "~> 1.2.0"

  required_providers {
    tailscale = {
      source  = "davidsbond/tailscale"
      version = "~> 0.12.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.26.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0.1"
    }
    # null = {
    #   source  = "hashicorp/null"
    #   version = ">= 3.1.1"
    # }
    # time = {
    #   source  = "hashicorp/time"
    #   version = "~> 0.8.0"
    # }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      ManagedBy = "terraform"
      Component = "tailscale"
    }
  }
}

provider "tailscale" {
  api_key = var.tailscale_api_key
  tailnet = var.tailscale_domain
}
