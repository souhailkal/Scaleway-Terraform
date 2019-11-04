#Poc
Provisioning files for Terraform to deploy a Kubernetes cluster to Scaleway.
=====

How to use:

1. Generate SSH keys for Scaleway and add it to the security section in Scaleway.
 SSH Key must have the name ``scw`` in repo ``keys``
2. Issue a token from your scaleway account.
3. Update terraform.tfvars with appropriate configuration values.
4. Run scripts in ``bin`` to build image and to provision your kubernetes cluster.
5. SSH to master by running "ssh -i /keys/scw -L 8001:localhost:8001 root@masterip
6. Run proxy in master to access the cluster UI with "kubectl proxy"
7. Use the Token in k8s-dashboard-token.txt to login
8. Use this link to access Kubernetes dashboard "http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login"

