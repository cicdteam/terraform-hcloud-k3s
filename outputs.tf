output "master_ipv4" {
  depends_on  = [module.master]
  description = "Public IP Address of the master node"
  value       = module.master.master_ipv4
}


output "nodes_ipv4" {
  depends_on  = [module.node_group]
  description = "Public IP Address of the worker nodes in groups"
  value = {
    for type, n in module.node_group :
    type => n.node_ipv4
  }
}
