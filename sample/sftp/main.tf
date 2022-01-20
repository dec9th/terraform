resource "aws_s3_bucket" "s3_bucket" {
  bucket = "dec9th-sftp"
}

resource "aws_eip" "sftp_eip" {
  count = length(var.subnet_ids)
  vpc = true
  tags = {
    Name = "dec9th-sftp-eip"
  }
}

resource "aws_security_group" "sg_sftp" {
  name        = "sg_sftp"
  description = "sample security group for sftp"
  vpc_id      = var.vpc_id

  ingress {
    description = "at-home"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  
  ingress {
    description = "tmp-cloud9"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["13.124.176.236/32"]
  }
  
  # it doesn't care that allowing tcp 443 exists
  # egress {
  #   description = "connect_s3"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  tags = {
    Name = "sg_sftp"
  }
}

resource "aws_transfer_server" "sftp_server" {
  domain                  = "S3"
  endpoint_type           = "VPC"
  protocols               = ["SFTP"]
  identity_provider_type  = "SERVICE_MANAGED"
  security_policy_name    = "TransferSecurityPolicy-2020-06"
  logging_role            = "arn:aws:iam::${var.account_id}:role/service-role/AWSTransferLoggingAccess"
  
  endpoint_details {
    vpc_id                  = var.vpc_id 
    subnet_ids              = var.subnet_ids
    security_group_ids      = [aws_security_group.sg_sftp.id]
    address_allocation_ids  = aws_eip.sftp_eip.*.id # EIP
  }


  tags = {
    Name = "dec9th-sftp"
  }
}
