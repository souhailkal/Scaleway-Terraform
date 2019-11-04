resource "scaleway_server" "kubernetes_master" {
  name           = "kubernetes_master"
  image          = "${data.scaleway_image.Debian-Stretch-9.id}"
  type           = "${var.scaleway_master_type}"
  security_group = "${scaleway_security_group.cluster_default.id}"
  public_ip      = "${scaleway_ip.master_ip.ip}"

  connection {
    type        = "ssh"
    user        = "${var.user}"
    private_key = "${file(var.kubernetes_ssh_key_path)}"
  }

  provisioner "file" {
    source      = "../share/k8s-master.sh"
    destination = "/tmp/k8s-master.sh"
  }

  provisioner "remote-exec" {
    inline = "bash /tmp/k8s-master.sh"
  }

  provisioner "file" {
    source      = "../kubernetes/k8s-dashboard.yaml"
    destination = "/tmp/k8s-dashboard.yaml"
  }

  provisioner "remote-exec" {
    inline = "kubectl apply -f /tmp/k8s-dashboard.yaml"
  }

  provisioner "file" {
    source      = "../kubernetes/k8s-admin-dashboard-user.yaml"
    destination = "/tmp/k8s-admin-dashboard-user.yaml"
  }

  provisioner "remote-exec" {
    inline = "kubectl apply -f /tmp/k8s-admin-dashboard-user.yaml"
  }

  provisioner "remote-exec" {
    inline = "curl -L https://git.io/getLatestIstio | sh - > istio_instalation.txt"
  }

  provisioner "remote-exec" {
    inline = "cat istio_instalation.txt | tail -n1 > path_istio.txt"
  }

  provisioner "remote-exec" {
    inline = "kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}') > k8s-dashboard-admin-token.txt"
  }

  provisioner "remote-exec" {
    inline = "cat k8s-dashboard-admin-token.txt | tail -n1 | awk '{ print $2; }' > k8s-dashboard-token.txt"
  }

  provisioner "local-exec" {
    command = "ssh-keygen -f ~/.ssh/known_hosts -R ${scaleway_ip.master_ip.ip}"
  }

  provisioner "local-exec" {
    command = "scp -o \"StrictHostKeyChecking no\" -i ${var.kubernetes_ssh_key_path} root@${scaleway_ip.master_ip.ip}:~/k8s-join-master.sh ../share/"
  }

  provisioner "local-exec" {
    command = "scp -o \"StrictHostKeyChecking no\" -i ${var.kubernetes_ssh_key_path} root@${scaleway_ip.master_ip.ip}:~/k8s-dashboard-token.txt ../share/"
  }

  provisioner "local-exec" {
    command = "scp -o \"StrictHostKeyChecking no\" -i ${var.kubernetes_ssh_key_path} root@${scaleway_ip.master_ip.ip}:~/path_istio.txt ../share/"
  }

  provisioner "file" {
    source      = "../share/path_istio.txt"
    destination = "/tmp/path_istio.txt"
  }

  provisioner "remote-exec" {
    inline = "bash /tmp/path_istio.txt"
  }

  provisioner "remote-exec" {
    inline = "for i in istio*/install/kubernetes/helm/istio-init/files/crd*yaml; do kubectl apply -f $i; done"
  }

  provisioner "remote-exec" {
    inline = "kubectl apply -f istio*/install/kubernetes/istio-demo-auth.yaml"
  }
}
