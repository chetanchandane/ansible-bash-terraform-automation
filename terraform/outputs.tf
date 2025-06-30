output "public_dns" {
  value = aws_instance.secure_vm.public_dns
}

output "public_ip" {
  value = aws_instance.secure_vm.public_ip
}
