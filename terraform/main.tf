resource "aws_instance" "secure_vm" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

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
