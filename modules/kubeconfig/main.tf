data "template_file" "setkubeconfig" {
  template = file("${path.module}/templates/setkubeconfig")
  vars = {
    cluster_name = var.cluster_name
    master_ipv4 = var.master_ipv4
  }
}

resource "local_file" "setkubeconfig" {
    content     = data.template_file.setkubeconfig.rendered
    filename = "./setkubeconfig"
    file_permission = "0755"
}

data "template_file" "unsetkubeconfig" {
  template = file("${path.module}/templates/unsetkubeconfig")
  vars = {
    cluster_name = var.cluster_name
  }
}

resource "local_file" "unsetkubeconfig" {
    content     = data.template_file.unsetkubeconfig.rendered
    filename = "./unsetkubeconfig"
    file_permission = "0755"

    provisioner "local-exec" {
        when    = destroy
        command = "./unsetkubeconfig"
    }
}

