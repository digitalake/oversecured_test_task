output "app_instances_internal_ips" {
  description = "Internal IP addresses of the app instances"
  value       = { for instance in aws_instance.app_instance : instance.tags.Name => instance.private_ip }
}

output "bastion_host_public_ip" {
  description = "Public IP address of the bastion instance"
  value       = aws_instance.bastion.public_ip
}

output "load_balancer_dns_name" {
  description = "Public DNS name of the load balancer"
  value       = aws_lb.external_lb.dns_name
}

output "user_credentials" {
  value = {
    password = aws_iam_user_login_profile.oversecured_user_login_profile.password
    username = aws_iam_user.oversecured_user.name
  }
}

