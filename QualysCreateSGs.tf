provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAY45KLEWNHO432SQ4"
  secret_key = "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"
}

locals {
  common_tags = {
    Environment = "PRD"
    Epic = "All"
    SquadOwner = "TechTeam"
    CostCenter = "Shared"
    Createdby = "Console"
    IAMBlock = "Yes"
  }
}

variable "vpcs" {
  type = list
  default = ["vpc-c83228ae", "vpc-0e0ae3f97ecc1d0bf", "vpc-0e625e87c36651dfe", "vpc-09915bfeab9d0a5e4", "vpc-0dc3c32c1f52848b6"]
}

variable "vpcs_map" {
  type = map
  default = {
    vpc-c83228ae = "Main"
    vpc-0e0ae3f97ecc1d0bf = "Second"
    vpc-0e625e87c36651dfe = "Third"
    vpc-09915bfeab9d0a5e4 = "Fourth"
    vpc-0dc3c32c1f52848b6 = "Fifth"
  }
}

variable "qualys_cloud" {
  type = string
  default = "64.39.96.0/20"
}

resource "aws_security_group" "qualys_sgs" {
  for_each    = var.vpcs_map
  name        = format("%s%s","SG_Qualys_VPC_",each.value)
  description = "Allow Qualys traffic"
# For use with variable "vpcs"
#  count       = length(var.vpcs)
#  name       = format("%s%s","SG_Qualys_VPC_",var.vpcs[count.index])
#  vpc_id      = element(var.vpcs,count.index)

  ingress {
    description = "Qualys Cloud"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [ var.qualys_cloud ]
  }

  ingress {
    description = "Endpoint EC2 e STS"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [ "192.168.121.159/32" ]
  }

  ingress {
    description = "Endpoint EC2 e STS"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [ "192.168.122.214/32" ]
  }

  ingress {
    description = "Endpoint EC2 e STS"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [ "192.168.184.138/32" ]
  }

  ingress {
    description = "Endpoint EC2 e STS"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [ "192.168.137.252/32" ]
  }

  ingress {
    description = "Endpoint EC2 e STS"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [ "192.168.165.102/32" ]
  }

  egress {
    description = "Qualys Cloud"
    from_port   = 0
    to_port     = 65535
    protocol    ="udp"
    cidr_blocks = [ var.qualys_cloud ]
  }

  egress {
    description = "Qualys Cloud"
    from_port   = 0
    to_port     = 65535
    protocol    ="tcp"
    cidr_blocks = [ var.qualys_cloud ]
  }

  egress {
    description = "Endpoint EC2 e STS"
    from_port   = 443
    to_port     = 443
    protocol    ="tcp"
    cidr_blocks = [ "192.168.121.159/32" ]
  }

  egress {
    description = "Endpoint EC2 e STS"
    from_port   = 443
    to_port     = 443
    protocol    ="tcp"
    cidr_blocks = [ "192.168.121.102/32" ]
  }

  egress {
    description = "Endpoint EC2 e STS"
    from_port   = 443
    to_port     = 443
    protocol    ="tcp"
    cidr_blocks = [ "192.168.122.214/32" ]
  }

  egress {
    description = "Endpoint EC2 e STS"
    from_port   = 443
    to_port     = 443
    protocol    ="tcp"
    cidr_blocks = [ "192.168.184.138/32" ]
  }

  egress {
    description = "Endpoint EC2 e STS"
    from_port   = 443
    to_port     = 443
    protocol    ="tcp"
    cidr_blocks = [ "192.168.137.252/32" ]
  }

  egress {
    description = "Endpoint SG"
    from_port   = 0
    to_port     = 65535
    protocol    ="tcp"
    security_groups = [ vars.destination_SG ]
  }

  egress {
    description = "Endpoint SG"
    from_port   = 0
    to_port     = 65535
    protocol    ="tcp"
    security_groups = [ vars.destination_SG ]
  }

  tags = local.common_tags
}

resource "aws_instance" "qualys_appliance" {
  ami           = ami-0e8abb4e85bb06f3e
  instance_type = "t2.medium"

  tags = local.common_tags
  }
}
