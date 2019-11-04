output "To ssh to master use" {
  value = "ssh -i scw -L 8001:localhost:8001 root@${scaleway_server.kubernetes_master.public_ip}"
}

output "Use the Token in k8s-dashboard-token.txt to login" {
  value = "cat ./share/k8s-dashboard-token.txt"
}

output "Use this link to access Kubernetes dashboard" {
  value = "http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login"
}
