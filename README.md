# This is a collection of projects that i have worked on

### Projects list
1. [Installation of High Availability Kubernetes cluster](/AmrSioufy/Projects/blob/main/HA-Kubernetes-Installation)
2. [Integrating on-premise LDAP Active Directory with Kubernetes cluster for user authentication in self-service applications(K8s Dashboard, Kubeapps) (WORK IN PROGRESS) ](/AmrSioufy/Projects/blob/main/keycloak-ldap-integration)


----------------------------------------------------------------------------------------------------------------------------------------------------------------------

### PROJECT ONE 
#### [Installation of High Availability Kubernetes cluster with the following specifications and deployments](/AmrSioufy/Projects/blob/main/keycloak-ldap-integration) ####

` spec: `

  &minus; `container_runtime: CRI-O `
  
  &minus; `kubernetes_version: 1.23`
  
  &minus; `os-relase: RedHat 8.5`
  
  &minus; `Swap, SELinux & Firewall disabled`
  
  &minus; `mounted nfs server`

env:

` #some deployments are deployed by helm (bitnami charts)`

  &minus; `CNI: Flannel` 
  
  &minus; `NFS-Provisioner`
  
  &minus; `MetalLB `
  
  &minus; `Nginx ingress controller`
  
  &minus; `MongoDB`
  
  &minus; `Prometheus and Grafana`
  
  &minus; `DMZ Node`
  
  &minus; `EFK (Elastic, Fluentd, Kibana)`
 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
### PROJECT TWO ###
#### [Integrating on-premise LDAP Active Directory with Kubernetes cluster for user authentication in self-service applications(K8s Dashboard, Kubeapps) (WORK IN PROGRESS) ](/AmrSioufy/Projects/blob/main/keycloak-ldap-integration) ####
