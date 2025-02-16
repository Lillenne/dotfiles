# Follow the fedora promps
sudo dnf update -y
# install firefox gnome shell ext
sudo dnf install gnome-pomodoro.x86_64 -y
sudo dnf install gnome-shell-extension-netspeed.noarch -y
#noannoyance doesn't seem to be working
# git clone https://github.com/bdaase/noannoyance.git
# mkdir /home/aus/.local/share/gnome-shell/extensions
# mv noannoyance ~/.local/share/gnome-shell/extensions/noannoyance@daase.net
# activate in gnome-tweaks

driveloc='/run/media/aus/T7 Shield/F38'
cp $(driveloc)/.bashrc ~/.bashrc

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install akmod-nvidia -y # rhel/centos users can use kmod-nvidia instead
sudo dnf install xorg-x11-drv-nvidia-cuda -y

sudo dnf install dotnet-sdk-7.0 -y
#install rider && echo 'export PATH=$PATH:/home/aus/Rider/bin' >> ~/.bashrc

sudo dnf install alacritty -y
sudo dnf install neovim -y
/usr/bin/python3 -m pip install pynvim
sudo dnf install npm -y
sudo npm install -g neovim
sudo dnf install ripgrep fd-find -y
curl -L https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz | tar xz
chmod +x gdu_linux_amd64
sudo mv gdu_linux_amd64 /usr/bin/gdu
sudo dnf copr enable atim/bottom -y
sudo dnf install bottom
#lazygit
sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit
# in nvim :Codeium Auth

#misc config
cp $(driveloc)/.config ~/.config

# vscode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
sudo dnf install code
# install llvm plugin

sudo dnf install emacs libtool -y
cp $(driveloc)/autostart/emacs.desktop ~/.config/autostart/emacs.desktop
echo 'export PATH=$PATH:~/.config/emacs/bin' >> ~/.bashrc
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
rm -rf ~/.config/doom/
cp $(driveloc)/doom/* ~/.config/doom/*
doom sync

# mail
cp $(driveloc)/.mbsyncrc ~/.mbsyncrc
sudo dnf install git meson gmime30-devel xapian-core-devel -y
sudo dnf install maildir-utils isync -y
mbsync --all
mu init --maildir ~/.mail --my-address austinkearns47@gmail.com

sudo dnf install gcc-g++

#cp $(driveloc)/nerd-fonts ~/nerd-fonts
#cd nerd-fonts
#./install.sh

#Download and run cuds .runfile
#mv cuda .run & sudo ./cuda*.run

#cudnn
tar -xvf cudnn-linux-*-archive.tar.xz
sudo cp cudnn-*-archive/include/cudnn*.h /usr/local/cuda/include
sudo cp -P cudnn-*-archive/lib/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

# OpenCV
sudo dnf install cmake python-devel numpy gtk2-devel libdc1394-devel libv4l-devel ffmpeg-devel gstreamer1-plugins-base-devel -y
sudo dnf install libpng-devel libjpeg-turbo-devel jasper-devel openexr-devel libtiff-devel libwebp-devel -y
sudo dnf install tbb-devel eigen3-devel doxygen -y
sudo dnf install tesseract-devel
sudo dnf install ninja-build-1.10.2-9.fc37.x86_64

#opencv build params from $opencv_dir/build
cmake -GNinja -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_EXAMPLES=OFF -DWITH_EIGEN=ON -DWITH_TBB=ON -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/usr/local -DWITH_CUDA=ON -DOPENCV_ENABLE_NONFREE=ON -DWITH_CUDNN=ON -DENABLE_FAST_MATH=1 -DCUDA_FAST_MATH=1 -DWITH_CUBLAS=1 -DOPENCV_DNN_CUDA=ON -DCUDA_ARCH_BIN=8.9 -DWITH_GSTREAMER=ON -DARCH=sm_89 -DWITH_NVCUVID=ON ..


# for rust cv
sudo dnf install clang-devel llvm-devel -y

# WG
sudo dnf install wireguard-tools -y
#download wg files - sudo mv * /etc/wireguard/

#postgres
sudo dnf install postgresql postgresql-server -y
sudo postgresql-setup --initdb --unit postgresql
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo su - postgres
psql
\password postgres
#password here & retype
\q

#in project
dotnet tool install --global dotnet-ef
#dotnet add package Microsoft.EntityFrameworkCore.Design
#dotnet ef migrations add InitialCreate
dotnet ef database update


#minio
firewall-cmd --permanent --zone=public --add-port=9000/tcp
firewall-cmd --reload

wget https://dl.min.io/server/minio/release/linux-amd64/archive/minio-20230718174940.0.0.x86_64.rpm -O minio.rpm
sudo dnf install minio.rpm -y
#create the systemd service
#sudo su
groupadd -r minio-user
useradd -M -r -g minio-user minio-user
#create env file /etc/default/minio
sudo mkdir /home/minio
#mv certs to /home/minio/.minio/certs
#TODO https://min.io/docs/minio/linux/integrations/setup-nginx-proxy-with-minio.html

sudo dnf install syncthing -y

sudo dnf install jetbrains-mono-fonts-2.304-1.fc37

# install kubernetes
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
EOF

sudo dnf install kubectl kubeadm  -y
# enable kubernetes bash completion for all users
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
sudo chmod a+r /etc/bash_completion.d/kubectl

#Forward ipv4 and let iptables see bridged traffic
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
# Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

sudo dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet

#still need to install container runtime
#
#
#
#
sudo dnf remove zram-generator-defaults -y

sudo dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf install containerd.io
#sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
#sudo systemctl enable docker
#
# to remove
#sudo rm -rf /var/lib/docker
#sudo rm -rf /var/lib/containerd
#
sudo containerd config default > /etc/containerd/config.toml

# [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
#  ...
#  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
#    SystemdCgroup = true
sudo systemctl enable containerd
sudo systemctl start containerd

# TODO set firewalld default network interface to fedora workstation & bind that to interfaces
# install calico
#https://docs.tigera.io/calico/latest/getting-started/kubernetes/
# export DATASTORE_TYPE=kubernetes
# autocert: https://github.com/smallstep/autocert#tutorial--demo
# sudo firewall-cmd --permanent --zone=FedoraWorkstation --add-port=179/tcp
# sudo firewall-cmd --permanent --zone=FedoraWorkstation --add-service=https
# unsure why this isn't working on s4mini, but swap is re-enabling on boot despite removing zram-generator & commenting out in /etc/fstab.
sudo swapoff -a
#need to configure default storage class for volume claims and volumes - create a storage class yaml
# may need to restart kubelet and containerd services after reboot for some reason
#

# postgres for in container
# /var/lib/pgsql/data/postgresql.conf -> listen_addresses = '*'
# /var/lib/pgsql/data/pg_hba.conf -> host    all         all         192.168.1.0/24    md5
# podman run -p5050:80 localhost/viewer --ConnectionStrings:viewer_users="User ID=postgres;Password=postgres;Host=host.containers.internal;Port=5432;Database=viewer;"


# echo 'Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"' >> /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
#
#


#todo install helm
# helm repo add metallb https://metallb.github.io/metallb
# helm install metallb metallb/metallb

# calicoctl create -f - <<EOF
# apiVersion: projectcalico.org/v3
# kind: BGPConfiguration
# metadata:
#   name: default
# spec:
#   serviceClusterIPs:
#   - cidr: 10.96.0.0/16
#   - cidr: fd00:1234::/112
# EOF
# calicoctl patch BGPConfig default --patch '{"spec": {"serviceLoadBalancerIPs": [{"cidr": "10.11.0.0/16"},{"cidr":"10.1.5.0/24"}]}}'
#

### attempt 2 - flannel
kubeadm init --pod-network-cidr=10.244.0.0/16

kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl taint nodes --all node-role.kubernetes.io/master-

mkdir -p /opt/cni/bin
curl -O -L https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz
tar -C /opt/cni/bin -xzf cni-plugins-linux-amd64-v1.2.0.tgz

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# cpy key
sm # ssh to s4mini
sudo swapoff -a
#paste & join
#
# flannel
mkdir -p /opt/cni/bin
curl -O -L https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz
tar -C /opt/cni/bin -xzf cni-plugins-linux-amd64-v1.2.0.tgz
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
#metallb
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.11/config/manifests/metallb-native.yaml
# works if turn off firewall
# sudo firewall-cmd --permanent --add-port=7472/tcp --zone=FedoraWorkstation
# sudo firewall-cmd --permanent --add-port=7472/udp --zone=FedoraWorkstation
# sudo firewall-cmd --permanent --add-port=7946/tcp --zone=FedoraWorkstation
# sudo firewall-cmd --permanent --add-port=7946/udp --zone=FedoraWorkstation
sudo firewall-cmd --add-service=http --zone=FedoraWorkstation --permanent
sudo firewall-cmd --add-service=https --zone=FedoraWorkstation --permanent
sudo firewall-cmd --reload
firewall-cmd --zone=trusted --add-source=10.0.0.0/8 --permanent # hack for now..
# maybe? https://stackoverflow.com/questions/67083713/metallb-works-only-in-master-node-cant-reach-ip-assigned-from-workers -- I did apply these & they didn't appear to work. Might need to remove


# install helm
sudo dnf install helm
#helm install nginx-ingress oci://ghcr.io/nginxinc/charts/nginx-ingress
#helm repo add nginx-stable https://helm.nginx.com/stable
#helm repo update
#helm install nginx-ingress nginx-stable/nginx-ingress --set rbac.create=true --set controller.service.externalTrafficPolicy=Cluster

helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace  --set controller.service.externalTrafficPolicy=Cluster
#helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
#helm repo update
#helm install ingress-nginx ingress-nginx/ingress-nginx

# prep metallb
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

# on ovps did ufw allow from 172.16.16.0/24
# ufw route allow in on wg0 # did it! - done on server vps
# https://serverfault.com/questions/991306/how-can-i-route-all-traffic-through-one-interface-to-another-interface-but-sen

sudo firewall-cmd --add-source=10.0.0.0/8 --permanent

#sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 172.16.16.10:80
#sudo iptables -t nat -A POSTROUTING -p tcp -d 172.16.16.10 --dport 80 -j SNAT --to-source 172.16.16.3

# promising below..
# firewall-cmd --zone=public \
  #--add-forward-port=port=80:proto=tcp:toport=8080:toaddr=172.16.0.2
#didn't do it

# make sure setenforce 0
# see how i got it working in /etc/wireguard/wg0.conf !
#
# configure ufw to route 80/443 to kubernetes endpoint

# https://www.baeldung.com/linux/ufw-port-forward
# echo 'net/ipv4/ip_forward=1' >> /etc/ufw/sysctl.conf
# add to /etc/ufw/before.rules @ the top
#  ### ADDED BY ME!

# *nat
# :PREROUTING ACCEPT [0:0]
# -A PREROUTING -p tcp -i ens3 --dport 80 -j DNAT --to-destination 192.168.1.173:80
# -A PREROUTING -p tcp -i ens3 --dport 443 -j DNAT --to-destination 192.168.1.173:80
# COMMIT

# ### END ADDED BY ME!
#

# own docker registry
#openssl req -newkey rsa:4096 -nodes -sha256 -keyout domain.key -x509 -days 365 -out domain.crt
#kubectl create secret tls docker-registry-certs --cert=domain.crt --key=domain.key
#trust self signed -- didn't work
#https://github.com/containers/podman/blob/main/docs/tutorials/podman-install-certificate-authority.md
# https://docs.docker.com/registry/configuration/#letsencrypt

# add to /etc/containers/registries.conf
# [[registry]]
# location = 192.168.144.1
# insecure = true

# cert-manager : https://www.howtogeek.com/devops/how-to-install-kubernetes-cert-manager-and-configure-lets-encrypt/
helm repo add jetstack https://charts.jetstack.io

helm repo update
# --namespace cert-manager --create-namespace --version v1.5.3
helm install cert-manager jetstack/cert-manager --set installCRDs=true
#kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml

# cert-manager kubectl plugin
curl -L -o kubectl-cert-manager.tar.gz https://github.com/jetstack/cert-manager/releases/latest/download/kubectl-cert_manager-linux-amd64.tar.gz
tar xzf kubectl-cert-manager.tar.gz
sudo mv kubectl-cert_manager /usr/local/bin


# PostUp = iptables -t nat -A PREROUTING -i $sv_interface -p tcp --dport $sv_port -j DNAT --to-destination $cl_ip:$cl_port
# PostUp = iptables -A FORWARD -i $sv_interface -o $wg_interface -p tcp --syn --dport $sv_port -m conntrack --ctstate NEW -j ACCEPT
# PostUp = iptables -A FORWARD -i $sv_interface -o $wg_interface -p tcp --dport $sv_port -m conntrack --ctstate ESTABLISHED -j ACCEPT
# PostUp = iptables -A FORWARD -i $wg_interface -o $sv_interface -p tcp --sport $cl_port -m conntrack --ctstate ESTABLISHED -j ACCEPT
# PostUp = iptables -t nat -A POSTROUTING -o $wg_interface -p tcp --dport $sv_port -d $cl_ip -j SNAT --to-source $sv_ip
#
# curl lb addr goes through interface flannel.1
# forward ovps -> dark -> lb -o flannel.1
# remove forward rule to lb ?

# nothing working for some reason. Forwarding from ovps -> dark, run nginx on dark w/proxy pass to correct endpoint

## Dark nginx conf - /etc/nginx/conf.d/pixalyzer.conf
# upstream kub {
# 	server 192.168.20.20:80;
# }
# upstream kubs {
# 	server 192.168.20.20:443;
# }
# server {
#  listen 80 default_server;
#  underscores_in_headers on;
#  location / {
# 	 proxy_set_header Host $http_host;
#          proxy_pass_request_headers      on;
# 	 proxy_pass http://kub;
#  }
# }

# server {
#  listen 443 default_server;
#  underscores_in_headers on;
#  location / {
# 	 proxy_set_header Host $http_host;
#          proxy_pass_request_headers      on;
# 	 proxy_pass https://kubs;
#  }
# }

# delete helm cert manager
# helm --namespace cert-manager delete cert-manager
# kubectl delete namespace cert-manager
# kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/vX.Y.Z/cert-manager.crds.yaml
#

http: TLS handshake error from 10.244.0.1:14660: remote error: tls: bad certificate
ACME server URL host and ACME private key registration host differ.
configured acme dns01 nameservers nameservers=["10.96.0.10:53"]
try newer cert manager -- might just be timing out?
pod dns issue?? most likely this with wg up? am i not forwarding
make sure to remove the secrets
why is the cloudflare key not working? maybe make a token
otherwise just load balance outside the cluster..

try all the things:
#kubelet & runtime
systemctl stop kubelet
systemctl stop docker / crio
# default accept first?
iptables --flush
iptables -tnat --flush
systemctl start kubelet
systemctl start docker / crio

#coredns deployment
kubectl rollout restart deployment coredns --namespace

#proxy
kubectl delete pod -n kube-system kube-proxy-xxx-xxx

#firewalld
systemctl stop firewalld
systemctl disable firewalld

https://github.com/k3s-io/k3s/issues/1608
I found out why --flannel-iface wg0 was failing for me:
Using AllowedIPs = 0.0.0.0/0 and wg-quick up does some fwmark magic in the background and gets caught by the kubernetes firewall iptables rules. Manually defining my wireguard network and the k3s CIDRs as AllowedIPs works with wg-quick up.

I still do have the cert-manager problems though:

    Internal error occurred: failed calling webhook "webhook.cert-manager.io": unexpected error when reading response body. Please retry. Original error: context deadline exceeded

set nginx hostnetowrk
chart: nginx-ingress-controller
    helm:
      parameters:
        - name: daemonset.useHostPort
          value: "true"
        - name: hostNetwork
          value: "true"
        - name: kind
          value: DaemonSet
        - name: replicaCount
          value: "1"
    repoURL: https://charts.bitnami.com/bitnami
    targetRevision: 7.5.0


    try decreasing wg mtu?

    appears to be working now after forwarding to s4 and running commands not on wg w/ clusterissuer

htpasswd -Bc htpasswd admin

sudo dnf install nginx-mod-stream
# to /etc/nginx/nginx.conf add OUTSIDE of the http block
# include /etc/nginx/stream.conf.d/*.conf
stream {
      upstream kub {
            server 192.168.20.20:443;
      }
      server {
            listen 443;
            proxy_pass kub;
            #ssl_preread on; # not sure if this is needed
      }
}

-Bbn <your_username> <your_password> > auth/htpasswd

maybe need ssl passthrough?
https://stackoverflow.com/questions/52911053/nginx-ssl3-get-record-wrong-version-number-502-bad-gateway
maybe try just running nginx on ovps...

running nginx on ovps now... still not working... must be the https proxying..l

# worked for docker registry when forwarded directly to dark using ufw
sudo podman run --privileged -d   --restart=always   --name registry   -v "$(pwd)":/certs   -e REGISTRY_HTTP_ADDR=0.0.0.0:443   -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/pix-cert.pem   -e REGISTRY_HTTP_TLS_KEY=/certs/pix-key.pem   -p 443:443   registry:2

i think the problem is nginx ingress isn't doing ssl passthrough



# building emacs
# missing first steps for build/compile emacs
sudo dnf install -y texinfo
sudo dnf install -y ImageMagick
sudo dnf install -y ImageMagick-devel
sudo dnf install gtk3-devel -y
sudo dnf install -y webkit2gtk4.0-devel
sudo dnf install libgccjit libgccjit-devel -y

git clone https://github.com/tree-sitter/tree-sitter.git
cd tree-sitter
make -j$(nproc)
sudo make install
sudo ldconfig

sudo dnf install gnutls-devel jansson-devel -y
# export LD_LIBRARY_PATH=/usr/local/lib/
git clone https://github.com/casouri/tree-sitter-module.git
./tree-sitter-module/batch.sh

sudo dnf install libtree-sitter-devel -y
./configure --with-json --with-pgtk --with-tree-sitter --with-mailutils --with-native-compilation=aot --with-imagemagick --with-xwidgets --with-modules

