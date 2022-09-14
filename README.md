# This is a collection of projects that i have worked on

### Projects list
Installation of High Availability Kubernetes cluster with the following specifications and deployments.

spec:

  &minus; container_runtime: CRI-O
  
  &minus; kubernetes_version: 1.23
  
  &minus; os-relase: RedHat 8.5
  
  &minus; Swap, SELinux & Firewall disabled
  
  &minus; mounted nfs server
  
env:

- some deployments are deployed by helm (bitnami charts)

  &minus; CNI: Flannel 
  
  &minus; NFS-Provisioner
  
  &minus; MetalLB 
  
  &minus; Nginx ingress controller
  
  &minus; MongoDB
  
  &minus; Prometheus and Grafana
  
  &minus; EFK (Elastic, Fluentd, Kibana)
  
