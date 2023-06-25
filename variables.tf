#-----------------------Naming-Vars
variable "project_prefix" {
  description = "Resource naming prefix"
  type        = string
  default     = "ovsectest"
}

#-----------------------Placement-Vars
variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "az" {
  type        = list(string)
  description = "avaliability zone"
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

#-----------------------Network-Vars
variable "vpc_cidr" {
  type        = string
  description = "CIDR vlock in vpc"
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR for the public subnet"
  default     = "10.0.0.0/24"
}

variable "public_subnet1_cidr" {
  type        = string
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "public_subnet2_cidr" {
  type        = string
  description = "CIDR block for the public subnet"
  default     = "10.0.2.0/24"
}

#-----------------------Instances-conf-Vars

variable "vms" {
  description = "Map of vm names/configuration."
  type = map(object({
    instance_type = string,
    instance_ami  = string
  }))
}

variable "bastion_instance_type" {
  description = "An instance type for Bastion host"
  type        = string
  default     = "t2.micro"
}

variable "bastion_instance_ami" {
  description = "An ami to use for Bastion host"
  type        = string
  default     = "ami-04e601abe3e1a910f"
}

variable "ssh_keys_location" {
  description = "A directory with ssh keys"
  type        = string
  default     = "/home/yakimoro/.ssh/"
}

variable "priv_key_name" {
  description = "Private ssh key name"
  type        = string
  default     = "oversecured_test"
}

variable "pub_key_name" {
  description = "Public ssh key name"
  type        = string
  default     = "oversecured_test.pub"
}