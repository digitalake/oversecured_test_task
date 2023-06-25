resource "aws_key_pair" "bastion_ssh_key" {
  key_name   = "${var.project_prefix}-bastion_ssh_key"
  public_key = file("${var.ssh_keys_location}${var.pub_key_name}")
}

resource "aws_instance" "bastion" {
  ami           = var.bastion_instance_ami
  instance_type = var.bastion_instance_type
  key_name      = aws_key_pair.bastion_ssh_key.key_name
  subnet_id     = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]
  tags = {
    Name = "${var.project_prefix}-bastion"
  }
}

resource "aws_lb" "external_lb" {
  name               = "${var.project_prefix}-external-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets = [
    aws_subnet.public_subnet1.id,
    aws_subnet.public_subnet2.id
  ]
  tags = {
    Name = "${var.project_prefix}-external-lb"
  }
}

resource "aws_lb_target_group" "external_lb_target_group" {
  name_prefix = "target"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.project_vpc.id

  health_check {
    path     = "/"
    protocol = "HTTP"
  }
}

resource "aws_lb_listener" "external_lb_listener" {
  load_balancer_arn = aws_lb.external_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.external_lb_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "external_lb_listener_rule" {
  listener_arn = aws_lb_listener.external_lb_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_lb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/currency"]
    }
  }
}


resource "aws_lb_target_group_attachment" "external_lb_target_group_attachment" {
  for_each         = var.vms
  target_group_arn = aws_lb_target_group.external_lb_target_group.arn
  target_id        = aws_instance.app_instance[each.key].id
}

