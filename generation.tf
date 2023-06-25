resource "local_file" "ssh_proxy_conf" {
  content = templatefile("${path.module}/tf_templates/ssh_proxy_conf.tpl", {
    bastion_ip    = aws_instance.bastion.public_ip
    bastion_name  = aws_instance.bastion.tags.Name
    identity_file = "/home/yakimoro/.ssh/${var.priv_key_name}"
    nodes = tomap({
      for instance in aws_instance.app_instance : instance.tags.Name => instance.private_ip
    })
  })
  filename = "${path.module}/ansible/ssh_proxy_conf"
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/tf_templates/ansible_inventory.tpl",
    {
      nodes = [for instance in aws_instance.app_instance : instance.tags.Name]
    }
  )
  filename = "${path.module}/ansible/ansible_inventory"
}