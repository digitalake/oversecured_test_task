%{ if length(bastion_ip) > 0 ~}
Host ${bastion_name}
  HostName  ${bastion_ip}
  IdentityFile ${identity_file}
  User ubuntu
  StrictHostKeyChecking no

%{ for nodes_key, nodes_value in nodes ~}
Host ${nodes_key}
  HostName ${nodes_value}
  IdentityFile ${identity_file}
  User ubuntu
  ProxyJump ${bastion_name}
  StrictHostKeyChecking no
%{ endfor ~}
%{ endif ~}
