export kube_api_public_endpoint=${KUBE_API_PUBLIC_ENDPOINT}
export cluster_name=${CLUSTER_NAME}

# Causes the shell to treat unset variables as errors and exit immediately
set -o nounset

# We needed to match the hostname expected by kubeadm and the hostname used by kubelet
private_ip_address=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
hostname="$(curl -s http://169.254.169.254/latest/meta-data/hostname)"

# Create Kubeadm configuration
tee -a kubeadm.config.yaml <<EOF
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
nodeRegistration:
  kubeletExtraArgs:
    cloud-provider: aws
  name: $hostname
  taints:
    - effect: NoSchedule
      key: node-role.kubernetes.io/master
localAPIEndpoint:
  advertiseAddress: $private_ip_address
  bindPort: 6443

---

apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
controlPlaneEndpoint: "$kube_api_public_endpoint:6443"
apiServer:
  certSANs:
    - $private_ip_address
    - $hostname
  extraArgs:
    cloud-provider: aws
    feature-gates: "ExpandPersistentVolumes=true"
clusterName: $cluster_name
controllerManager:
  extraArgs:
    cloud-provider: aws
    configure-cloud-routes: "false"
networking:
  podSubnet: 192.168.0.0/16
EOF

# Initialize Kubeadm
sudo kubeadm init --config ./kubeadm.config.yaml

# Placing kubeconfig file in ~/.kube/config
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Calico
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/tigera-operator.yaml &&
  kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/custom-resources.yaml

# Get the Kubeadm join command
sudo kubeadm token create --print-join-command >kubeadm-join.sh
