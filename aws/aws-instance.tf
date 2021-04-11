# Instance Key
resource "aws_key_pair" "mc-instance-key" {
  key_name                = "mc-ssh-key${random_string.mc-random.result}"
  public_key              = var.instance_key
  tags                    = {
    Name                    = "mc-ssh-key"
  }
}

# Instance(s)
resource "aws_instance" "mc-instance" {
  ami                     = aws_ami_copy.mc-latest-vendor-ami-with-cmk.id
  instance_type           = var.instance_type
  iam_instance_profile    = aws_iam_instance_profile.mc-instance-profile.name
  key_name                = aws_key_pair.mc-instance-key.key_name
  subnet_id               = aws_subnet.mc-pubnet.id
  private_ip              = var.pubnet_instance_ip
  vpc_security_group_ids  = [aws_security_group.mc-pubsg.id]
  tags                    = {
    Name                    = "${var.name_prefix}-instance-${random_string.mc-random.result}",
    "${var.name_prefix}-ssm-target-${random_string.mc-random.result}" = "True"
  }
  root_block_device {
    volume_size             = var.instance_vol_size
    volume_type             = "standard"
    encrypted               = "true"
    kms_key_id              = aws_kms_key.mc-kmscmk-ec2.arn
  }
  depends_on              = [aws_iam_role_policy_attachment.mc-iam-attach-ssm, aws_iam_role_policy_attachment.mc-iam-attach-s3]
}

# Elastic IP for Instance(s)
resource "aws_eip" "mc-eip-1" {
  vpc                     = true
  instance                = aws_instance.mc-instance.id
  associate_with_private_ip = var.pubnet_instance_ip
  depends_on              = [aws_internet_gateway.mc-gw]
}
