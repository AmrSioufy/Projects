#############################################################################################################################################
#                                                                                                                                           #
#                                                     /\ This is my Kubernetes documentation /   \                                          #
#                                                                                                                                           #
#############################################################################################################################################
#############################################################################################################################################
#                                                                ..        ..                                                               #
#                                                                /\ TOPICS /\                                                               #
#                                       1. Mount and Initialize AppStream/BaseOS Local Repo                                                 #
#                                       2. TurnOff SELinux & Stop Firewall & TurnOff Swap                                                   #
#                                       3. Modify /etc/hosts                                                                                #
#                                       4. Pass and modify iptables variables                                                               #
#                                       5. Install CRI-O                                                                                    #
#                                       6. Add Kubernetes repo and Install Kubectl, Kubeadm, Kubelet                                        #
#                                       7. Initialize and Join Master nodes                                                                 #
#                                       8. Install Flannel CNI                                                                              #
#                                       9. Autocompletion of Bash and Kubernetes                                                            #
#                                       10. Install NFS Provisioning                                                                        #
#                                       11. Deploy MetalLB LoadBalancer tool                                                                #
#                                       12. Deploy Nginx Ingress Controller                                                                 #
#                                       13. Deploy MongoDB                                                                                  #
#                                       14. Creating an Ingress record                                                                      #
#                                       15. Deploy Prometheus and Grafana                                                                   #
#                                       16. Deploying Elastic,Fluentd,Kibana [EFK] Stack                                                    #
#                                                                                                                                           #
#############################################################################################################################################

#############################################################################################################################################
#                                         // Following the official kubernetes.io documentation and other sources \\
#
#      https://itnext.io/security-zones-in-openshift-worker-nodes-part-i-introduction-4f85762962d7
#      https://www.securityandit.com/
#      https://bitnami.com/stacks/helm
#      https://www.securityandit.com/network/best-practices-for-web-network-segmentation-in-kubernetes/
#      https://graspingtech.com/install-kubernetes-rhel-8/
#      https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
#      https://www.tecmint.com/install-nfs-server-on-centos-8/
#      https://itnext.io/kubernetes-storage-part-1-nfs-complete-tutorial-75e6ac2a1f77
#      https://kubernetes.github.io/ingress-nginx/user-guide/multiple-ingress/
#      https://kubernetes.github.io/ingress-nginx/user-guide/basic-usage/                                                                                                                  #
#
#############################################################################################################################################
#############################################################################################################################################
#                                                1. Mount and Initialize AppStream/BaseOS Local Repo                                        #
#                                                                                                                                           #
#                                                                 \\ Steps //                                                               #
#                                                       - Mount iso image to a directory                                                    #
#                                                       - Modify /etc/fstab                                                                 #
#                                                       - Configure baseurl                                                                 #
#############################################################################################################################################
##Make sure baseurl is correct in each configuration##
mkdir /repo_mountpoint/
lsblk -fp #show iso image UUID, FSTYPE, Mountpoint
nano /etc/fstab #edit fstab with mount specifications
#Example:
'
UUID=2021-10-13-03-57-25-00 /repo_mountpoint       iso9660     defaults        0 0
'
mount /repo_mountpoint/
vi /etc/yum.repos.d/rhel8.repo

'
[InstallMedia-BaseOS]
name=Red Hat Enterprise Linux 8 - BaseOS
metadata_expire=-1
gpgcheck=1
enabled=1
baseurl=file:///repo_mountpoint/BaseOS/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

[InstallMedia-AppStream]
name=Red Hat Enterprise Linux 8 - AppStream
metadata_expire=-1
gpgcheck=1
enabled=1
baseurl=file:///repo_mountpoint/AppStream/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

'
chmod 644 /etc/yum.repos.d/rhel8.repo
- use 'mount | grep MOUNTPOINT' to validate the above.
'=========================================================================================================================================='
#############################################################################################################################################
#                                                        2. SELinux, Firewalld, Swap                                                        #
#                                                                                                                                           #
#                                                                 \\ Steps //                                                               #
#                                                       - Turnoff SELinux, Edit config file                                                 #
#                                                       - Modify /etc/fstab to delete swap                                                  #
#                                                       - Disable & Stop firewalld                                                          #
#############################################################################################################################################
#Turnoff SELinux#
#navigate to: /etc/selinux/config and set it to permissive
setenforce 0
sed -i s/^SELINUX=.*$/SELINUX=permissive/ /etc/selinux/config
systemctl daemon-reload
sudo sed -i '/swap/d' /etc/fstab #Removes swap in fstab
sudo swapoff -a 
systemctl disable firewalld
systemctl stop firewalld

#Only if firewall is on
firewall-cmd --add-port=6443/tcp --permanent
10250
~
firewall-cmd --reload
'=========================================================================================================================================='
#############################################################################################################################################
#                                                                3. /etc/hosts                                                              #
#                                                                                                                                           #
#                                                                 \\ Steps //                                                               #
#                                                       - Modify the /etc/hosts to have all nodes set                                       #
#############################################################################################################################################




###Installing CRI-O###
export VERSION=1.23    #Specify the current Kubernetes version!!
export OS=CentOS_8
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo  https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_8/devel:kubic:libcontainers:stable.repo
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo  https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/CentOS_8/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo
sudo yum install cri-o -y
systemctl enable crio
systemctl start crio

#repo configurations

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg  https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

sudo yum install -y kubelet-1.23.0 kubectl-1.23.0 kubeadm-1.23.0 --disableexcludes=kubernetes
sudo systemctl enable kubelet

#######################################################################################################################################################################
###Network configurations###
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-arptables = 1
EOF
sysctl --system

#######################################################################################################################################################################
###Changing container runtime endpoint###
#in /etc/crictl.yaml the endpoint by default is unix:///var/run/cri-dockerd.sock
#We want to make sure correct endpoint is created.

#######################################################################################################################################################################
###ERRORS SECTION###

##localhost port 6443## fix :
sudo -i
swapoff -a
exit
strace -eopenat kubectl version
---------------------------------------
#localhost port 8080## fix:
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#OR

export KUBECONFIG=/etc/kubernetes/admin.conf
----------------------------------------
##CrashLoopBackOff can't reach resource group service account in nginx-controller##
Solution1:
kubectl delete pod PODNAME
systemctl restart crio
systemctl restart kubelet

Solution2:
kubectl create clusterrolebinding ingress -n ingress-nginx --clusterrole=cluster-admin --serviceaccount=ingress-nginx:ingress-nginx
-----------------------------------------

#######################################################################################################################################################################
###(NOTES SECTION###)###
#To create master node
kubeadm init --control-plane-endpoint="10.0.12.50:6443" --upload-certs --apiserver-advertise-address=10.0.12.51 --pod-network-cidr=10.244.0.0/16
#To join master node
kubeadm join 192.168.9.130:6443 --token tp57eq.jwue4q0hfrunm8pp \
	--discovery-token-ca-cert-hash  sha256:27c838754492c20401016be740e453ef5808b1ba2973a8fd158e3a6b245e6639
#Worker node not ready
cat /etc/hosts #check if worker node hostname is correctly set

#######################################################################################################################################################################
###CNI (Flannel)###
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

#######################################################################################################################################################################
##Dashboard##
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml

##Apply Service account YAML

apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard


##Apply Cluster Role binding YAML

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard

#Generate a token for login

##K8s 1.23 or lower ## kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
##K8s 1.24 or higher ## kubectl -n kubernetes-dashboard create token admin-user


##############################################################################################################################################################################################################################################################################################################################################
##Metallb##

#We use metallb to get external ip addresses binded to the cluster ip of services deployed
#We will deploy the original deployment
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.4/config/manifests/metallb-native.yaml

#Then, We need to apply the following yaml file for Layer 2 address pool
#IP Addresses are according to your environment

---
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.240-192.168.1.250
---
#Then we apply the L2Advertisement yaml file
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: example
  namespace: metallb-system
spec:
  ipAddressPools:
  - first-pool
---

#######################################################################################################################################################################
##Nginx-ingress-controller##
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/cloud/deploy.yaml


#######################################################################################################################################################################
##HAProxy##
#Edit /etc/hosts with ipaddress and hostname of the HAProxy server
yum install haproxy -y
#The following path is the configuration path /etc/haproxy/haproxy.cfg

frontend load_balancer
    bind 10.128.0.48:80
    option http-server-close
    option forwardfor
    stats uri /haproxy?stats

default_backend   webservers

backend webservers
    mode        http
    balance     roundrobin
    stats       enable
    stats auth  linuxtechi:Techi@1234
    option httpchk HEAD / HTTP/1.1\r\nHost:\ localhost
    server  apache-web-1  10.128.0.49:80
    server  apache-web-2  10.128.0.50:80

#######################################################################################################################################################################
##Helm##
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

###NFS Provisioning###
#Create a NFS server and make an export path
mkdir /mnt/data
#Edit /etc/exports with the following
/mnt/data *(rw,no_subtree_check,no_root_squash)
#Execute the export and make sure to enable and start NFS server
exportfs -ar
systemctl enable nfs-server
systemctl start nfs-server

#Using the below manifests we will apply them.
#PersistentVolume YAML
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-volume
  labels:
    storage.k8s.io/name: nfs
spec:
  accessModes:
    - ReadWriteOnce
    - ReadOnlyMany
    - ReadWriteMany
  capacity:
    storage: 10Gi
  storageClassName: ""
  persistentVolumeReclaimPolicy: Recycle
  volumeMode: Filesystem
  nfs:
    server: *NFSSERVER-IPADDRESS*
    path: /mnt/data
    readOnly: no

#Dynamic provisioning using StorageClass
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --create-namespace \
  --namespace nfs-provisioner \
  --set nfs.server=10.0.12.67 \
  --set nfs.path=/mnt/data

#PersistentVolumeClaim YAML
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs-test
  labels:
    storage.k8s.io/name: nfs
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: nfs-client
  resources:
    requests:
      storage: 1Gi
#######################################################################################################################################################################
##Prometheus and Grafana##
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm install prometheus prometheus-community/kube-prometheus-stack

#Grafana#
kubectl edit svc prometheus-grafana -n default #edit the service type to LoadBalancer

kubectl edit secret prometheus-grafana #Decode base64 username and password
#decoded credentials:
 #username : admin
 #password : prom-operator

kubectl edit deployment deployment.apps/prometheus-grafana #Under livenessProbe: edit to initialDelaySeconds: 5
#######################################################################################################################################################################
##MongoDB##
#We will add a values file to the chart for the persistence
helm install -f mongovalues.yaml my-release bitnami/mongodb

get values file here: https://github.com/bitnami/charts/blob/master/bitnami/mongodb/values.yaml
edit global StorageClass in Persistence:
>>>>  StorageClass: "nfs-client"

**If the container is not ready, extend time for liveness and readiness probes.
#######################################################################################################################################################################
##Elasticsearch##
helm repo add bitnami https://charts.bitnami.com/bitnami

#We will add a values file to the chart for the persistence
helm install -f elasticvalues.yaml es-release bitnami/elasticsearch

get values file here:  https://github.com/bitnami/charts/blob/master/bitnami/elasticsearch/values.yaml
edit global StorageClass in Persistence:
>>>>  StorageClass: "nfs-client"

#To deploy kibana with elasticsearch, make sure you have this in your values file below, as you can see we have "kibanaEnabled: True"

global:
  namespace: efk
  imageRegistry: ""
  ## E.g.
  ## imagePullSecrets:
  ##   - myRegistryKeySecretName
  ##
  imagePullSecrets: []
  storageClass: "nfs-client"
  elasticsearch:
    service:
      name: elasticsearch
      ports:
        restAPI: 9200
  kibanaEnabled: True


Elasticsearch can be accessed within the cluster on port 9200 at elasticsearch.default.svc.cluster.local

#######################################################################################################################################################################
###Kibana##
#This is a deployment of kibana excluded from elasticsearch joint deploy from the above.
helm install -f kibanavalues.yaml kibana-release bitnami/kibana

!!#We need to specify Elasticsearch ip and port in the values file!!
** Kibana needs the external ip of the elasticsearch service **

get values file here: https://github.com/bitnami/charts/blob/master/bitnami/kibana/values.yaml
Also! edit global StorageClass in Persistence:
>>>>  StorageClass: "nfs-client"



helm install -f kibanavalues.yaml kibana bitnami/kibana \
  --set elasticsearch.enabled=false \
  --set elasticsearch.external.hosts[0]=elasticsearch.default.svc.cluster.local \
  --set elasticsearch.external.port=9200 \
  --set service.type=LoadBalancer

#######################################################################################################################################################################
##Fluentd##
#We need to create the following configmaps
#first one is fluentd aggregator for elasticsearch
#second one is apache log parser for fluentd forwarder

#first one
apiVersion: v1
kind: ConfigMap
metadata:
  name: elasticsearch-output
data:
  fluentd.conf: |

    # Ignore fluentd own events
    <match fluent.**>
      @type null
    </match>

    # TCP input to receive logs from the forwarders
    <source>
      @type forward
      bind 0.0.0.0
      port 24224
    </source>

    # HTTP input for the liveness and readiness probes
    <source>
      @type http
      bind 0.0.0.0
      port 9880
    </source>

    # Throw the healthcheck to the standard output instead of forwarding it
    <match fluentd.healthcheck>
      @type stdout
    </match>

    # Send the logs to the standard output
    <match **>
      @type elasticsearch
      include_tag_key true
      host "#{ENV['ELASTICSEARCH_HOST']}"
      port "#{ENV['ELASTICSEARCH_PORT']}"
      logstash_format true
      <buffer>
        @type file
        path /opt/bitnami/fluentd/logs/buffers/logs.buffer
        flush_thread_count 2
        flush_interval 5s
      </buffer>
    </match>

#second one
apiVersion: v1
kind: ConfigMap
metadata:
  name: apache-log-parser
data:
  fluentd.conf: |

    # Ignore fluentd own events
    <match fluent.**>
      @type null
    </match>

    # HTTP input for the liveness and readiness probes
    <source>
      @type http
      port 9880
    </source>

    # Throw the healthcheck to the standard output instead of forwarding it
    <match fluentd.healthcheck>
      @type stdout
    </match>

    # Get the logs from the containers running in the cluster
    # This block parses logs using an expression valid for the Apache log format
    # Update this depending on your application log format
    <source>
      @type tail
      path /var/log/containers/*.log
      pos_file /opt/bitnami/fluentd/logs/buffers/fluentd-docker.pos
      tag www.log
      <parse>
        @type regexp
        expression /^(?<host>[^ ]*) [^ ]* (?<user>[^ ]*) \[(?<time>[^\]]*)\] \\"(?<method>\S+)(?: +(?<path>[^ ]*) +\S*)?\\" (?<code>[^ ]*) (?<size>[^ ]*)(?: "(?<referer>[^\"]*)" "(?<agent>[^\"]*)")?$/
        time_format %d/%b/%Y:%H:%M:%S %z
      </parse>
    </source>

    # Forward all logs to the aggregators
    <match **>
      @type forward
      <server>
        host fluentd-0.fluentd-headless.default.svc.cluster.local
        port 24224
      </server>

      <buffer>
        @type file
        path /opt/bitnami/fluentd/logs/buffers/logs.buffer
        flush_thread_count 2
        flush_interval 5s
      </buffer>
    </match>

helm install fluentd bitnami/fluentd \
  --set aggregator.configMap=elasticsearch-output \
  --set forwarder.configMap=apache-log-parser \
  --set aggregator.extraEnv[0].name=ELASTICSEARCH_HOST \
  --set aggregator.extraEnv[0].value=elasticsearch.default.svc.cluster.local \
  --set aggregator.extraEnv[1].name=ELASTICSEARCH_PORT \
  --set-string aggregator.extraEnv[1].value=9200 \
  --set forwarder.extraEnv[0].name=FLUENTD_DAEMON_USER \
  --set forwarder.extraEnv[0].value=root \
  --set forwarder.extraEnv[1].name=FLUENTD_DAEMON_GROUP \
  --set forwarder.extraEnv[1].value=root

#######################################################################################################################################################################
##Kafka##
#We will add a values file to the chart for the persistence
helm install -f kafkavalues.yaml kafka bitnami/kafka

get values file here:  https://github.com/bitnami/charts/blob/master/bitnami/kafka/values.yaml
edit global StorageClass in Persistence:
>>>>  StorageClass: "nfs-client"
#######################################################################################################################################################################
##DMZ Ingress##Multiple nginx controllers##
#First of all edit the official deployment manifest of nginx-ingress-controller to resolve to dmz namespace

#We need to taint a node with our preferances
kubectl taint NODENAME zone=dmz:NoSchedule

#We also need to label our node with zone: dmz

#Then specify the toleration of the tainted node in the deployment section of the nginx-ingress-controller + nodeSelector option as below
tolerations:
      - key: "zone"
        operator: "Equal"
        value: "dmz"
        effect: "NoSchedule"
      nodeSelector:
        zone: dmz

#Then make sure that the IngressClass controller in the "args:" section is different from the default one
#Apply the changes to the IngressClass kind as shown below *The controller name is now set to ingress-nginx-internal
#Make sure that the parameteres is set to scope: Namespace
#In our Ingress deployment we must specify a personal input hostname and http object as below pointing to service name.
#Dont forget to apply an Ingress deployment to the firstly deployed nginx controller to point for its IngressClass.

#Part of the nginx-ingress-controller default YAML
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
    app.kubernetes.io/version: 1.3.0
  name: nginx-internal
spec:
  controller: k8s.io/ingress-nginx-internal
  parameters:
    scope: Namespace
    kind: IngressParameter
    namespace: dmz
    name: namespaced-ingressconf
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-internal
  namespace: dmz
spec:
  ingressClassName: nginx-internal
  rules:
  - host: ingressdmz.example
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: ingress-nginx-controller
            port:
              number: 80

---
### Ingress Records ###
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: dashboard-ingress
  namespace: kubernetes-dashboard
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol:  "HTTPS"
spec:
  tls:
  - hosts:
      - kubernetes.ipn.mashreqbank.com
  ingressClassName: nginx
  rules:
  - host: kubernetes.ipn.mashreqbank.com
    http:
      paths:
      - backend:
          service:
            name: kubernetes-dashboard
            port:
              number: 443
        path: /
        pathType: Prefix
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grafana-ingress
  namespace: monitoring
spec:
  ingressClassName: nginx
  rules:
  - host: grafana.ipn.mashreqbank.com
    http:
      paths:
      - backend:
          service:
            name: prometheus-grafana
            port:
              number: 80
        path: /
        pathType: Prefix


##Scale down##
#To scale down multiple deployments
