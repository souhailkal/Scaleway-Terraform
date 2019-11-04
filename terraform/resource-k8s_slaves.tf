resource "scaleway_server" "kubernetes_slave" {
  count               = "2"
  name                = "${format("${var.kubernetes_cluster_name}-slave-%02d", count.index)}"
  depends_on          = ["scaleway_server.kubernetes_master"]
  image               = "${data.scaleway_image.Debian-Stretch-9.id}"
  dynamic_ip_required = "${var.dynamic_ip}"
  type                = "${var.scaleway_slave_type}"
  security_group      = "${scaleway_security_group.cluster_default.id}"

  connection {
    type        = "ssh"
    user        = "${var.user}"
    private_key = "${file(var.kubernetes_ssh_key_path)}"
  }

  provisioner "file" {
    source      = "../share/k8s-join-master.sh"
    destination = "/tmp/k8s-join-master.sh"
  }

  provisioner "remote-exec" {
    inline = "bash /tmp/k8s-join-master.sh"
  }
}
