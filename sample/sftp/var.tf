variable "vpc_id" {
  description = "AWS VPC"
  type        = string
  default     = "vpc-375b855e"
}

variable "subnet_ids" {
  description = "Subnet id list"
  default     = ["subnet-aa548cc3", "subnet-11718a6a","subnet-c2637888"]
}

variable "transfer_ssh_key_SANTA" {
  description = "type SANTA's ssh_key"
  sensitive   = true
  default     = "ssh-key already typed. # if you replace this, remove default"
  
  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^ssh-", var.transfer_ssh_key_SANTA))
    error_message = "The transfer_ssh_key_SANTA value must be a valid ssh key, starting with \"ssh-\"."
  }
  
}
