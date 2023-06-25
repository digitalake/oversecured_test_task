resource "aws_key_pair" "app_instance_ssh_key" {
  for_each   = var.vms
  key_name   = "${var.project_prefix}-${each.key}-app_instance_key"
  public_key = file("${var.ssh_keys_location}${var.pub_key_name}")
}

resource "aws_instance" "app_instance" {
  for_each               = var.vms
  ami                    = each.value.instance_ami
  instance_type          = each.value.instance_type
  key_name               = aws_key_pair.app_instance_ssh_key[each.key].key_name
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.application_vms_sg.id]

  tags = {
    Name = "${var.project_prefix}-${each.key}"
  }
}


