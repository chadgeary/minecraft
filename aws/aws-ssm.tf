# document to install deps and run playbook
resource "aws_ssm_document" "mc-ssm-doc" {
  name                    = "${var.name_prefix}-ssm-doc"
  document_type           = "Command"
  content                 = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "Ansible Playbooks via SSM for Ubuntu 18.04 ARM, installs Ansible properly.",
    "parameters": {
    "SourceType": {
      "description": "(Optional) Specify the source type.",
      "type": "String",
      "allowedValues": [
      "GitHub",
      "S3"
      ]
    },
    "SourceInfo": {
      "description": "Specify 'path'. Important: If you specify S3, then the IAM instance profile on your managed instances must be configured with read access to Amazon S3.",
      "type": "StringMap",
      "displayType": "textarea",
      "default": {}
    },
    "PlaybookFile": {
      "type": "String",
      "description": "(Optional) The Playbook file to run (including relative path). If the main Playbook file is located in the ./automation directory, then specify automation/playbook.yml.",
      "default": "hello-world-playbook.yml",
      "allowedPattern": "[(a-z_A-Z0-9\\-)/]+(.yml|.yaml)$"
    },
    "ExtraVariables": {
      "type": "String",
      "description": "(Optional) Additional variables to pass to Ansible at runtime. Enter key/value pairs separated by a space. For example: color=red flavor=cherry",
      "default": "SSM=True",
      "displayType": "textarea",
      "allowedPattern": "^$|^\\w+\\=[^\\s|:();&]+(\\s\\w+\\=[^\\s|:();&]+)*$"
    },
    "Verbose": {
      "type": "String",
      "description": "(Optional) Set the verbosity level for logging Playbook executions. Specify -v for low verbosity, -vv or vvv for medium verbosity, and -vvvv for debug level.",
      "allowedValues": [
      "-v",
      "-vv",
      "-vvv",
      "-vvvv"
      ],
      "default": "-v"
    }
    },
    "mainSteps": [
    {
      "action": "aws:downloadContent",
      "name": "downloadContent",
      "inputs": {
      "SourceType": "{{ SourceType }}",
      "SourceInfo": "{{ SourceInfo }}"
      }
    },
    {
      "action": "aws:runShellScript",
      "name": "runShellScript",
      "inputs": {
      "runCommand": [
        "#!/bin/bash",
        "# Ensure ansible is installed",
        "sudo apt-get update",
        "sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git",
        "sudo pip3 install --upgrade pip",
        "sudo pip3 install --upgrade ansible",
        "echo \"Running Ansible in `pwd`\"",
        "#this section locates files and unzips them",
        "for zip in $(find -iname '*.zip'); do",
        "  unzip -o $zip",
        "done",
        "PlaybookFile=\"{{PlaybookFile}}\"",
        "if [ ! -f  \"$${PlaybookFile}\" ] ; then",
        "   echo \"The specified Playbook file doesn't exist in the downloaded bundle. Please review the relative path and file name.\" >&2",
        "   exit 2",
        "fi",
        "ansible-playbook -i \"localhost,\" -c local -e \"{{ExtraVariables}}\" \"{{Verbose}}\" \"$${PlaybookFile}\""
      ]
      }
    }
    ]
  }
DOC
}

# ansible playbook association for tag:value prefix-ssm-target-suffix:True
resource "aws_ssm_association" "mc-ssm-assoc" {
  association_name        = "${var.name_prefix}-ssm-assoc"
  name                    = aws_ssm_document.mc-ssm-doc.name
  targets {
    key                   = "tag:${var.name_prefix}-ssm-target-${random_string.mc-random.result}"
    values                = ["True"]
  }
  output_location {
    s3_bucket_name          = aws_s3_bucket.mc-bucket.id
    s3_key_prefix           = "ssm"
  }
  parameters              = {
    ExtraVariables          = "SSM=True name_prefix=${var.name_prefix} mc_update=yes mc_memory=${var.mc_memory}"
    PlaybookFile            = "minecraft_aws.yml"
    SourceInfo              = "{\"path\":\"https://s3.${var.aws_region}.amazonaws.com/${aws_s3_bucket.mc-bucket.id}/playbook/\"}"
    SourceType              = "S3"
    Verbose                 = "-v"
  }
  depends_on              = [aws_iam_role_policy_attachment.mc-iam-attach-ssm, aws_iam_role_policy_attachment.mc-iam-attach-s3,aws_s3_bucket_object.mc-files]
}
