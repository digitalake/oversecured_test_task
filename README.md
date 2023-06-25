<h1 align="center">OVERSECURED TEST TASK</a> 
<img src="https://github.com/blackcater/blackcater/raw/main/images/Hi.gif" height="32"/></h1>

### Introduction
Hi there, for the task i was provided with i decided to use the most popular DevOps tools:
- Terraform
- Ansible
- Docker

The tasks for me were:
  - create infra with terraform using AWS
  - configure it with ansible
  - create the web page for the task
  - dockerize the page using nginx base image with all necessary stuff
  - deploy the nginx with ansible
  - perform user creation with right permissions


  
---


### Terraform

In this task the resources i decided to create are:
  - EC2 instance for web-server
  - Load Balancer for keeping the app server in private net
  - Bastion host for ssh connections
  - NAT and Internet Gateways
  - Necessary SGs
  - IAM user with policies
  - Necessary artifacts for ansible (ansible's dynamic inventory + ssh proxy jump config to jump through the Bastion)

An example of using Terraform templates for creating ssh config:

template:
```
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
```

result:
```
Host ovsectest-bastion
  HostName  52.59.212.202
  IdentityFile /home/yakimoro/.ssh/oversecured_test
  User ubuntu
  StrictHostKeyChecking no

Host ovsectest-nginx_server
  HostName 10.0.0.231
  IdentityFile /home/yakimoro/.ssh/oversecured_test
  User ubuntu
  ProxyJump ovsectest-bastion
  StrictHostKeyChecking no
```
I've used Terraform outputs for creating useful outputs:
```
app_instances_internal_ips = {
  "ovsectest-nginx_server" = "10.0.0.231"
}
bastion_host_public_ip = "52.59.212.202"
load_balancer_dns_name = "ovsectest-external-lb-1464192628.eu-central-1.elb.amazonaws.com"
user_credentials = {
  "password" = "************"
  "username" = "ovsectest-user"
}
```

Also Terraform creates the user with access to add or remove the rules from the Load Balancer's SG.

### Ansible

Using Ansible is a very efficient way to manage the infrastructure configuration and perform automated tasks on the remote hosts.

In this task i've used Ansible to prepare my server for deploying, so Ansible performs Docker instalation with __docker-spray__ role. Then it deploys The docker container using the Image was built and pushed to my Docker Hub.

### Docker 

You can find the Dockerfile in docker dir of the project.
The Dockerized Nginx uses HTML page with some CSS and the JS script for getting the data from the file.
The file is being filled with data using the python script which performs API call and writes the data into the file.
For executing script with some period, i implemented the cronjob which executes python script inside the container each hour.


### Using

Apply the Terraform, it will create the necessary configs for Ansible on ansible dir.

```
terraform apply
```
Change the dir:
```
cd ansible
```

Execute Ansible-playbook:
```
ansible-playbook -i ansible_inventory --ssh-extra-args '-F ssh_proxy_conf' deploy_nginx.yml
```

 The infra is ready, the app is deployed, the user is created
---




































