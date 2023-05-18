output "bastian_host_public_ip" {
  value = aws_instance.bastian_host.public_ip
}

output "master_node_private_ip" {
  value = aws_instance.master_node.private_ip
}
