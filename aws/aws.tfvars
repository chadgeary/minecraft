# SSH public key
instance_key = "ssh-rsa AAAAB3NzaC1ychange_me_change_me_change_me="

# AWS IAM user (not root)
kms_manager = "some_username"

# ip range permitted access to instance SSH and pihole webUI. Also granted DNS access if dns_novpn = 1.
# Deploying for home use? This should be your public IP address/32.
mgmt_cidr = "0.0.0.0/0"

# ip range(s) permitted access to the service port
client_cidrs = ["0.0.0.0/0"]

# memory megabytes dedicated to service, no less than 1024
mc_memory = "3072"

aws_region = "us-east-1"
instance_type = "t3a.medium"

# The Ubuntu ARM AMI name string, these are occasionally updated with a new date - replace us-east-1 with your region, then run the command:
# AWS_REGION=us-east-1 && ~/.local/bin/aws ec2 describe-images --region $AWS_REGION --owners 099720109477 --filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-arm64-server-*' 'Name=state,Values=available' --query 'sort_by(Images, &CreationDate)[-1].Name'
vendor_ami_name_string = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
vendor_ami_account_number = "099720109477"

## VERY UNCOMMON ##
# aws profile (e.g. from aws configure, usually "default")
aws_profile = "default"
instance_vol_size = 30
name_prefix = "minecraft"

# Change if ip settings would interfere with existing networks
vpc_cidr = "10.10.15.0/24"
pubnet_cidr = "10.10.15.0/26"
pubnet_instance_ip = "10.10.15.5"
