resource "null_resource" "kubeadm_init" {
  provisioner "remote-exec" {
    when       = create
    on_failure = fail

    connection {
      type  = "ssh"
      agent = false

      host        = aws_instance.master_node.private_ip
      user        = "ubuntu"
      private_key = tls_private_key.private_key.private_key_pem

      bastion_host        = aws_instance.bastian_host.public_ip
      bastion_user        = "ubuntu"
      bastion_private_key = tls_private_key.private_key.private_key_pem
    }

    inline = [
      file("${path.module}/scripts/kubeadm-installer.sh"),
      templatefile(
        "${path.module}/scripts/master-node.bootstrapper.sh",
        {
          KUBE_API_PUBLIC_ENDPOINT : aws_elb.this.dns_name,
          CLUSTER_NAME : var.cluster_name
        }
      )
    ]
  }

  depends_on = [aws_elb_attachment.master_node_elb_attachment]
}
