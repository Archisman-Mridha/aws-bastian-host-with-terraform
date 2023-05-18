resource "aws_instance" "master_node" {
  subnet_id = aws_subnet.private_subnet.id

  vpc_security_group_ids = [
    aws_security_group.cluster.id,
    // aws_security_group.kubeapi.id
  ]

  ami           = data.aws_ami.ubuntu.image_id
  instance_type = var.aws_instance_type
  root_block_device {
    volume_size = 25
  }

  key_name = aws_key_pair.this.key_name

  tags = {
    // Kubernetes uses tags to identify EC2 instances that it can use to schedule pods.
    // So this tag is compulsary.
    format("kubernetes.io/cluster/%v", var.cluster_name) = "owned"
  }

  lifecycle {
    ignore_changes = [
      ami,
      user_data,
      associate_public_ip_address
    ]
  }

  depends_on = [
    aws_instance.bastian_host
  ]
}

resource "aws_elb_attachment" "master_node_elb_attachment" {
  elb      = aws_elb.this.id
  instance = aws_instance.master_node.id
}
