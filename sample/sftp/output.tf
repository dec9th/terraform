output sftp_eips {
  value = aws_eip.sftp_eip.*.private_ip
}

output s3_bucket_id {
  value = aws_s3_bucket.s3_bucket.id
}

output sftp_server_endpoint {
  value = aws_transfer_server.sftp_server.endpoint
}