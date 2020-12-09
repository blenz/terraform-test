terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "ssh_key" {
  name = var.ssh_key
}

resource "digitalocean_project" "project" {
  name        = "${var.app_name}-${terraform.workspace}"
  description = "A project to test terraform"
  purpose     = "Web Application"
  environment = title(terraform.workspace)
  resources = [
    digitalocean_loadbalancer.loadbalancer.urn,
    digitalocean_droplet.droplet.urn
  ]
}

resource "digitalocean_firewall" "firewall" {
  name        = "${var.app_name}-${terraform.workspace}"
  droplet_ids = [digitalocean_droplet.droplet.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "80"
    source_load_balancer_uids = [digitalocean_loadbalancer.loadbalancer.id]
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "443"
    source_load_balancer_uids = [digitalocean_loadbalancer.loadbalancer.id]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0"]
  }
}

resource "digitalocean_vpc" "vpc" {
  name   = "${var.app_name}-${terraform.workspace}"
  region = "sfo2"
}

resource "digitalocean_loadbalancer" "loadbalancer" {
  name        = "${var.app_name}-${terraform.workspace}"
  region      = "sfo2"
  vpc_uuid    = digitalocean_vpc.vpc.id
  droplet_ids = [digitalocean_droplet.droplet.id]

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 80
    protocol = "tcp"
  }
}

resource "digitalocean_droplet" "droplet" {
  name               = "${var.app_name}-${terraform.workspace}"
  image              = "ubuntu-18-04-x64"
  size               = "512mb"
  region             = "sfo2"
  private_networking = true
  vpc_uuid           = digitalocean_vpc.vpc.id
  ssh_keys           = [data.digitalocean_ssh_key.ssh_key.id]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable'",
      "sudo apt update",
      "apt-cache policy docker-ce",
      "sudo apt install -y docker-ce"
    ]
  }
}
