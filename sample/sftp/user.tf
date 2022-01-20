resource "aws_iam_role" "sftp-role" {
  name = "tf-sftp-transfer-user-iam-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "sftp-policy" {
  name = "tf-sftp-transfer-user-iam-policy"
  role = aws_iam_role.sftp-role.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowListingOfHomeDir",
            "Action": [
                "s3:ListBucket"  
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::dec9th-sftp"
            ]
        },
        {
            "Sid": "HomeDirObjectAccess",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:GetObjectVersion",
                "s3:GetObjectACL",
                "s3:PutObjectACL"
            ],
            "Resource": "arn:aws:s3:::dec9th-sftp/*"
        }
    ]
}
POLICY

}

resource "aws_transfer_user" "sftp_user_SANTA" {
  server_id = "${aws_transfer_server.sftp_server.id}"
  user_name = "santa"
  role      = "${aws_iam_role.sftp-role.arn}"
  
#   home_directory_type ="PATH"
#   home_directory      = "/dec9th-sftp"
  
  home_directory_type ="LOGICAL"
  home_directory_mappings {
     entry  = "/"
     target = "/${aws_s3_bucket.s3_bucket.id}"
  }
}

resource "aws_transfer_ssh_key" "transfer_ssh_key_SANTA" {
  server_id = "${aws_transfer_server.sftp_server.id}"
  user_name = aws_transfer_user.sftp_user_SANTA.user_name
  body      = "${var.transfer_ssh_key_SANTA}"
  
  lifecycle {
    ignore_changes = all
  }
  
  depends_on = [aws_transfer_user.sftp_user_SANTA]
}

