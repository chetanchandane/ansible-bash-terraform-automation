variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "SSH key to connect to EC2"
  type        = string
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI"
  default     = "ami-0c02fb55956c7d316"  # Amazon Linux 2 (us-east-1)
}

variable "user_ip"{
    description = "the local IP address of the user"
    
}