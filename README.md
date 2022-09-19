# This is a collection of projects that i have worked on

### Projects list
1. [Installation of High Availability Kubernetes cluster](/AmrSioufy/Projects/blob/main/HA-Kubernetes-Installation)
2. [Integrating on-premise LDAP Active Directory with Kubernetes cluster for user authentication in self-service applications(K8s Dashboard, Kubeapps) (WORK IN PROGRESS) ](/AmrSioufy/Projects/blob/main/keycloak-ldap-integration)
3. [Installing traditonal webservers on CentOS, Ubuntu ](https://github.com/AmrSioufy/Projects/blob/main/Web%20Servers%20on%20different%20distros)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

### PROJECT ONE 
#### [Installation of High Availability Kubernetes cluster with the following specifications and deployments](/AmrSioufy/Projects/blob/main/keycloak-ldap-integration) 

` spec: `

  &minus; `container_runtime: CRI-O `
  
  &minus; `kubernetes_version: 1.23`
  
  &minus; `os-relase: RedHat 8.5`
  
  &minus; `Swap, SELinux & Firewall disabled`
  
  &minus; `mounted nfs server`

`env:`

` #some deployments are deployed by helm (bitnami charts)#`

  &minus; `CNI: Flannel` 
  
  &minus; `NFS-Provisioner`
  
  &minus; `MetalLB `
  
  &minus; `Nginx ingress controller`
  
  &minus; `MongoDB`
  
  &minus; `Prometheus and Grafana`
  
  &minus; `DMZ Node`
  
  &minus; ` EFK (Elastic, Fluentd, Kibana) `
  
 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
### PROJECT TWO ###
#### [Integrating on-premise LDAP Active Directory with Kubernetes cluster for user authentication in self-service applications(K8s Dashboard, Kubeapps) (WORK IN PROGRESS) ](/AmrSioufy/Projects/blob/main/keycloak-ldap-integration) ####

#### Scope
- The first approach taken is to authenticate groups of users in the LDAP active directory for a kubernetes cluster. This is where Keycloak's first job comes in as an authenticator using its (User federation). Keycloak is deployed in the cluster and administered by accessing its Ingress host.
- To authorize users imported from LDAP i needed oauth2 proxy to act as a reverse proxy to my services. Each service is integrated to keycloak as a new client in keycloak's realm. 
- keycloak will generate a JWT token to be used to authenticate the API user as well as to enable OAuth2 authorization for all OAuth protected APIs using OpenID Connect.
