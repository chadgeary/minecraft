output "aws-output" {
  value = <<OUTPUT
  
#############  
## OUTPUTS ##
#############
  
## SSH (VPN) ##
ssh ubuntu@${aws_eip.mc-eip-1.public_ip}
  
#############
## UPDATES ##
#############

# SSH to the server
ssh ubuntu@${aws_eip.mc-eip-1.public_ip}

# Use AWS CLI to re-run SSM association (ansible playbook) 
~/.local/bin/aws ssm start-associations-once --region ${var.aws_region} --association-ids ${aws_ssm_association.mc-ssm-assoc.association_id}

#############
## DESTROY ##
#############

# To destroy the project via terraform, run:
terraform destroy -var-file="aws.tfvars"

OUTPUT
}
