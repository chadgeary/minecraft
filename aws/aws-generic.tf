resource "random_string" "mc-random" {
  length                  = 5
  upper                   = false
  special                 = false
}

variable "aws_region" {
  type                     = string
}

variable "aws_az" {
  type                     = number
  default                  = 0
}

variable "aws_profile" {
  type                     = string
}

variable "vpc_cidr" {
  type                     = string
}

variable "pubnet_cidr" {
  type                     = string
}

variable "pubnet_instance_ip" {
  type                     = string
}

variable "mgmt_cidr" {
  type                     = string
  description              = "Subnet CIDR allowed to access SSH, e.g. home-ip-address/32 or 0.0.0.0/0"
}

variable "client_cidrs" {
  type                     = list
  description              = "List of CIDRs allowed to access service port, e.g. ['home ip address/32', 'secondary ip/32'] or ['0.0.0.0/0']"
  default                  = []
}

variable "instance_type" {
  type                     = string
  description              = "The type of EC2 instance to deploy"
}

variable "instance_key" {
  type                     = string
  description              = "A public key for SSH access to instance(s)"
}

variable "instance_vol_size" {
  type                     = number
  description              = "The volume size of the instances' root block device"
}

variable "name_prefix" {
  type                     = string
  description              = "A friendly name prefix for the AMI and EC2 instances, e.g. 'ph' or 'dev'"
}

variable "vendor_ami_account_number" {
  type                     = string
  description              = "The account number of the vendor supplying the base AMI"
}

variable "vendor_ami_name_string" {
  type                     = string
  description              = "The search string for the name of the AMI from the AMI Vendor"
}

provider "aws" {
  region                   = var.aws_region
  profile                  = var.aws_profile
}

# region azs
data "aws_availability_zones" "mc-azs" {
  state                    = "available"
}

# account id
data "aws_caller_identity" "mc-aws-account" {
}

variable "kms_manager" {
  type                     = string
  description              = "An IAM user for management of KMS key"
}

# kms cmk manager - granted access to KMS CMKs
data "aws_iam_user" "mc-kmsmanager" {
  user_name               = var.kms_manager
}

variable "mc_memory" {
  type                     = string
  description              = "Memory in megabytes for service, no less than 1024"
}
