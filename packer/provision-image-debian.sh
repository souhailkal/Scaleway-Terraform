sleep 5
apt-get clean
apt-get check
apt-get update

apt-get install -y apt-transport-https ca-certificates curl
apt-get install -y gnupg2 software-properties-common
apt-get update
		
echo "Installing DOCKER ..."
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce
systemctl enable docker && systemctl start docker

echo "Installing CNI ..."
CNI_VERSION="v0.6.0"
mkdir -p /opt/cni/bin
curl -L "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-amd64-${CNI_VERSION}.tgz" | tar -C /opt/cni/bin -xz

echo "Installing kubeadm, kubelet & kubectl ..."
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl 

systemctl daemon-reload
systemctl restart kubelet

apt-get clean
apt-get update
swapoff -a

echo "Setup Complete"


