data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "secure_sg" {
  name        = "secure-infra-sg"
  description = "Allow SSH, HTTP, and Flask Vault access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.user_ip}/32"]  # Replace this!
  }

  ingress {
    description = "Flask Vault (port 5050)"
    from_port   = 5050
    to_port     = 5050
    protocol    = "tcp"
    cidr_blocks = ["${var.user_ip}/32"]  # Replace this!
  }

  ingress {
    description = "HTTP (Apache)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "secure-infra-sg"
  }
}



resource "aws_instance" "secure_vm" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.secure_sg.id] 

  tags = {
    Name = "secure-infra-instance"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../vm_ip.txt"
    # We are saving the public IP to a file for later use(Ansible)
  }
}

output "instance_ip" {
  value = aws_instance.secure_vm.public_ip
}

