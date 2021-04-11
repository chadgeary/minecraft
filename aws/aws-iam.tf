# SSM Managed Policy
data "aws_iam_policy" "mc-instance-policy-ssm" {
  arn                     = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Policy S3
resource "aws_iam_policy" "mc-instance-policy-s3" {
  name                    = "mc-instance-policy-s3"
  path                    = "/"
  description             = "Provides instance access to s3 objects/bucket"
  policy                  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListObjectsinBucket",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": ["${aws_s3_bucket.mc-bucket.arn}"]
    },
    {
      "Sid": "GetObjectsinBucketPrefix",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ],
      "Resource": ["${aws_s3_bucket.mc-bucket.arn}/playbooks/*","${aws_s3_bucket.mc-bucket.arn}/pihole/*","${aws_s3_bucket.mc-bucket.arn}/wireguard/*"]
    },
    {
      "Sid": "PutObjectsinBucketPrefix",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": ["${aws_s3_bucket.mc-bucket.arn}/ssm/*"]
    },
    {
      "Sid": "S3CMK",
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": ["${aws_kms_key.mc-kmscmk-s3.arn}"]
    }
  ]
}
EOF
}

# Instance Role
resource "aws_iam_role" "mc-instance-iam-role" {
  name                    = "mc-instance-profile-${random_string.mc-random.result}-role"
  path                    = "/"
  assume_role_policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "sts:AssumeRole",
          "Principal": {
             "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": "mciprofile"
      }
  ]
}
EOF
}

# Instance Role Attachments
resource "aws_iam_role_policy_attachment" "mc-iam-attach-ssm" {
  role                    = aws_iam_role.mc-instance-iam-role.name
  policy_arn              = data.aws_iam_policy.mc-instance-policy-ssm.arn
}

resource "aws_iam_role_policy_attachment" "mc-iam-attach-s3" {
  role                    = aws_iam_role.mc-instance-iam-role.name
  policy_arn              = aws_iam_policy.mc-instance-policy-s3.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "mc-instance-profile" {
  name                    = "mc-instance-profile-${random_string.mc-random.result}"
  role                    = aws_iam_role.mc-instance-iam-role.name
}
