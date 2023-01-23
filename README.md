# This is a collection of projects that i have worked on

### Projects list
1. [Installation of High Availability Kubernetes cluster](https://github.com/AmrSioufy/Projects/blob/main/HA-Kubernetes-Installation)
2. [Integrating on-premise LDAP Active Directory with Kubernetes cluster for user authentication in self-service applications(K8s Dashboard, Kubeapps) (WORK IN PROGRESS) ](https://github.com/AmrSioufy/Projects/blob/main/K8s%20LDAP%20integration%20using%20keycloak)
3. [Linux based IoT Smart System to avoid collision between vehicles using Raspberry Pi](https://github.com/AmrSioufy/Raspberry-Pi)
4. [Installing traditonal webservers on CentOS, Ubuntu ](https://github.com/AmrSioufy/Projects/blob/main/Web_Servers_on_different_distros)
5. [Ansible Role for Installing a Kubernetes Cluster](https://github.com/AmrSioufy/Kubernetes-init)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------

### PROJECT ONE 
#### [Installation of High Availability Kubernetes cluster with the following specifications and deployments](https://github.com/AmrSioufy/Projects/blob/main/HA-Kubernetes-Installation) 

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
  
  &minus; `LoadBalancer: MetalLB `
  
  &minus; `Ingress Controller: Nginx ingress controller`
  
  &minus; `MongoDB`
  
  &minus; `Monitoring: Prometheus and Grafana`
  
  &minus; `Security: DMZ Node`
  
  &minus; `Logging: EFK (Elastic, Fluentd, Kibana) `
  
 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
### PROJECT TWO ###
#### [Integrating on-premise LDAP Active Directory with Kubernetes cluster for user authentication in self-service applications(K8s Dashboard, Kubeapps) (WORK IN PROGRESS) ](https://github.com/AmrSioufy/Projects/blob/main/K8s%20LDAP%20integration%20using%20keycloak) ####

#### Scope
- The first approach taken is to authenticate groups of users in the LDAP active directory for a kubernetes cluster. This is where Keycloak's first job comes in as an authenticator using its (User federation). Keycloak is deployed in the cluster and administered by accessing its Ingress host.
- To authorize users imported from LDAP i needed oauth2 proxy to act as a reverse proxy to my services. Each service is integrated to keycloak as a new client in keycloak's realm. 
- keycloak will generate a JWT token to be used to authenticate the API user as well as to enable OAuth2 authorization for all OAuth protected APIs using OpenID Connect.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
### PROJECT THREE ###
[Linux based IoT Smart System to avoid collision between vehicles using Raspberry Pi](https://github.com/AmrSioufy/Raspberry-Pi)
#### Architecture
- car_run.py > is the script that runs the car and processes data from distance sensor, stores car speed. based on that data decision is taken for different scenarios

- transmit.sh > transmits a file to a user in the same network using secure copy. 
To transmit a file you need to specify (Desitnation IP Address, Destination path, Destination username, Destination password, Path of transmitted files)

- Transmit.py > runs all scripts in a loop while continously sending files to a specified user using transmit.sh

- ultrasonic.py > distance sensor script
After reading the sensor readings, data is stored in a text file to be fetched later for a decision inside the "car_run.py"

*Every sensor script exports the data to a txt file which will be imported to the car_run.py for the buildup scenarios*

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

### PROJECT FOUR ###
[Installing traditonal webservers on CentOS, Ubuntu ](https://github.com/AmrSioufy/Projects/blob/main/Web%20Servers%20on%20different%20distros)
#### Scope
Installations are done on CentOS 7 8, Ubuntu
- Installed Apache, Nginx webservers while configuring SSL certs to its virtualhosts.
- Installed Wordpress 


### PROJECT FIVE ###
[Ansible Role for Installing a Kubernetes Cluster](https://github.com/AmrSioufy/Kubernetes-init) ~ https://github.com/AmrSioufy/Kubernetes-init

This project aims to design an Ansible Role to initiate a Kubernetes cluster.

The ansible role targeted 4 hosts:
```
1 master node
1 worker node
NFS server
HAProxy
```
This Role ensures that every managed host is configured for the following requirements:
```
1.Yum Local Repo
2.SELinux set to Permissive
3.Firewall is Disabled
4.No Swap is on the system
5.Modify /etc/hosts
6.Install CRI-O
7.Install Kubelet Kubectl Kubeadm
8.Install HAProxy on a dedicated host
9.Install NFS-Server on a dedicated host
10.Initiate Master-node
```
