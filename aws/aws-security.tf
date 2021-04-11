# security groups
resource "aws_security_group" "mc-pubsg" {
  name                    = "mc-pubsg"
  description             = "Security group for public traffic"
  vpc_id                  = aws_vpc.mc-vpc.id
  tags = {
    Name = "mc-pubsg"
  }
}

# public sg rules
resource "aws_security_group_rule" "mc-pubsg-mgmt-ssh-in" {
  security_group_id       = aws_security_group.mc-pubsg.id
  type                    = "ingress"
  description             = "IN FROM MGMT - SSH MGMT"
  from_port               = "22"
  to_port                 = "22"
  protocol                = "tcp"
  cidr_blocks             = [var.mgmt_cidr]
}

resource "aws_security_group_rule" "mc-pubsg-client-in" {
  count                   = length(var.client_cidrs) == 0 ? 0 : 1
  security_group_id       = aws_security_group.mc-pubsg.id
  type                    = "ingress"
  description             = "IN FROM CLIENT - SERVICE"
  from_port               = "25565"
  to_port                 = "25565"
  protocol                = "tcp"
  cidr_blocks             = var.client_cidrs
}

resource "aws_security_group_rule" "mc-pubsg-out-tcp" {
  security_group_id       = aws_security_group.mc-pubsg.id
  type                    = "egress"
  description             = "OUT TO WORLD - TCP"
  from_port               = 0
  to_port                 = 65535
  protocol                = "tcp"
  cidr_blocks             = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "mc-pubsg-out-udp" {
  security_group_id       = aws_security_group.mc-pubsg.id
  type                    = "egress"
  description             = "OUT TO WORLD - UDP"
  from_port               = 0
  to_port                 = 65535
  protocol                = "udp"
  cidr_blocks             = ["0.0.0.0/0"]
}
