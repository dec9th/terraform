variable "vpc_id" {
  description = "AWS VPC"
  type        = string
  default     = "vpc-375b855e"
}

variable "subnet_ids" {
  description = "Subnet id list"
  default     = ["subnet-aa548cc3", "subnet-11718a6a","subnet-c2637888"]
}

