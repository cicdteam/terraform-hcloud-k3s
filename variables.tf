variable "hcloud_token" {
  description = "Hetzner cloud auth token"
}

variable "cluster_name" {
  description = "Cluster name (prefix for all resource names)"
  default     = "hetzner"
}

variable "datacenter" {
  description = "Hetzner datacenter where resources resides, hel1-dc2 (Helsinki 1 DC 2) or fsn1-dc14 (Falkenstein 1 DC14)"
  default     = "hel1-dc2"
}

variable "image" {
  description = "Node boot image"
  default     = "ubuntu-20.04"
}

variable "network_cidr" {
  description = "CIDR of the private network"
  default     = "10.0.0.0/8"
}

variable "subnet_cidr" {
  description = "CIDR of the private network"
  default     = "10.0.0.0/24"
}

variable "master_type" {
  description = "Master node type (size)"
  default     = "cx21" # 2 vCPU, 4 GB RAM, 40 GB Disk space
}

variable "ssh_keys" {
  type        = list(any)
  description = "List of public ssh_key ids"
}

variable "k3s_channel" {
  default = "stable"
}

variable "node_groups" {
  description = "Map of worker node groups, key is server_type, value is count of nodes in group"
  type        = map(string)
  default = {
    "cx21" = 1
  }
}

variable "master_firewall_ids" {
  description = "A list of firewall IDs to apply on the master"
  type        = list(number)
  default     = []
}

variable "node_group_firewall_ids" {
  description = "A list of firewall IDs to apply on the node group servers"
  type        = list(number)
  default     = []
}
