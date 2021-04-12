provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_network" "private" {
  name     = var.cluster_name
  ip_range = var.network_cidr
}

resource "hcloud_network_subnet" "subnet" {
  network_id   = hcloud_network.private.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = var.subnet_cidr
}

resource "random_string" "k3s_token" {
  length  = 48
  upper   = false
  special = false
}

module "master" {
  source = "./modules/master"

  cluster_name = var.cluster_name
  datacenter   = var.datacenter
  image        = var.image
  node_type    = var.master_type
  ssh_keys     = var.ssh_keys

  hcloud_network_id = hcloud_network.private.id
  hcloud_subnet_id  = hcloud_network_subnet.subnet.id

  k3s_token   = random_string.k3s_token.result
  k3s_channel = var.k3s_channel

  hcloud_token = var.hcloud_token
  firewall_ids = var.master_firewall_ids
}

module "node_group" {
  source       = "./modules/node_group"
  cluster_name = var.cluster_name
  datacenter   = var.datacenter
  image        = var.image
  ssh_keys     = var.ssh_keys
  master_ipv4  = module.master.master_ipv4

  hcloud_subnet_id = hcloud_network_subnet.subnet.id

  k3s_token   = random_string.k3s_token.result
  k3s_channel = var.k3s_channel

  for_each     = var.node_groups
  node_type    = each.key
  node_count   = each.value
  firewall_ids = var.node_group_firewall_ids
}

module "kubeconfig" {
  source       = "./modules/kubeconfig"
  cluster_name = var.cluster_name
  master_ipv4  = module.master.master_ipv4
}

