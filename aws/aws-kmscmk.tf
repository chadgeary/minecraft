resource "aws_kms_key" "mc-kmscmk-s3" {
  description             = "Key for ph s3"
  key_usage               = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation     = "true"
  tags                    = {
    Name                  = "mc-kmscmk-s3"
  }
  policy                  = <<EOF
{
  "Id": "mc-kmskeypolicy-s3",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_iam_user.mc-kmsmanager.arn}"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow EC2 Encrypt",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.mc-instance-iam-role.arn}"
      },
      "Action": [
        "kms:Encrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:CallerAccount": "${data.aws_caller_identity.mc-aws-account.account_id}",
          "kms:ViaService": "ec2.${var.aws_region}.amazonaws.com"
        }
      }
    },
    {
      "Sid": "Allow access through S3",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.mc-instance-iam-role.arn}"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:CallerAccount": "${data.aws_caller_identity.mc-aws-account.account_id}",
          "kms:ViaService": "s3.${var.aws_region}.amazonaws.com"
        }
      }
    }
  ]
}
EOF
}

resource "aws_kms_alias" "mc-kmscmk-s3-alias" {
  name                    = "alias/mc-ksmcmk-s3"
  target_key_id           = aws_kms_key.mc-kmscmk-s3.key_id
}

resource "aws_kms_key" "mc-kmscmk-ec2" {
  description             = "Key for ph ec2/ebs"
  key_usage               = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation     = "true"
  tags                    = {
    Name                  = "mc-kmscmk-ec2"
  }
  policy                  = <<EOF
{
  "Id": "mc-kmskeypolicy-ec2",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_iam_user.mc-kmsmanager.arn}"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow attachment of persistent resources",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.mc-instance-iam-role.arn}"
      },
      "Action": [
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant"
      ],
      "Resource": "*",
      "Condition": {
        "Bool": {
          "kms:GrantIsForAWSResource": "true"
        }
      }
    },
    {
      "Sid": "Allow access through EC2",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.mc-instance-iam-role.arn}"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:CallerAccount": "${data.aws_caller_identity.mc-aws-account.account_id}",
          "kms:ViaService": "ec2.${var.aws_region}.amazonaws.com"
        }
      }
    }
  ]
}
EOF
}

resource "aws_kms_alias" "mc-kmscmk-ec2-alias" {
  name                    = "alias/mc-ksmcmk-ec2"
  target_key_id           = aws_kms_key.mc-kmscmk-ec2.key_id
}

resource "aws_kms_key" "mc-kmscmk-ssm" {
  description             = "Key for ph ssm"
  key_usage               = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation     = "true"
  tags                    = {
    Name                  = "mc-kmscmk-ssm"
  }
  policy                  = <<EOF
{
  "Id": "mc-kmskeypolicy-ssm",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_iam_user.mc-kmsmanager.arn}"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow access through EC2",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.mc-instance-iam-role.arn}"
      },
      "Action": "kms:Decrypt",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:CallerAccount": "${data.aws_caller_identity.mc-aws-account.account_id}",
          "kms:ViaService": "ssm.${var.aws_region}.amazonaws.com"
        }
      }
    }
  ]
}
EOF
}

resource "aws_kms_alias" "mc-kmscmk-ssm-alias" {
  name                    = "alias/mc-ksmcmk-ssm"
  target_key_id           = aws_kms_key.mc-kmscmk-ssm.key_id
}
