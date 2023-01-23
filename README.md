<<<<<<< HEAD
# This is a collection of projects that i have worked on

### Projects list
1. [Installation of High Availability Kubernetes cluster](https://github.com/AmrSioufy/Projects/blob/main/HA-Kubernetes-Installation)
2. [Integrating on-premise LDAP Active Directory with Kubernetes cluster for user authentication in self-service applications(K8s Dashboard, Kubeapps) (WORK IN PROGRESS) ](https://github.com/AmrSioufy/Projects/blob/main/K8s%20LDAP%20integration%20using%20keycloak)
3. [Linux based IoT Smart System to avoid collision between vehicles using Raspberry Pi](https://github.com/AmrSioufy/Raspberry-Pi)
4. [Installing traditonal webservers on CentOS, Ubuntu ](https://github.com/AmrSioufy/Projects/blob/main/Web%20Servers%20on%20different%20distros)
5.
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
=======
The design of this role may not be following the best practice standards for a role so excuse my design :)

Role Name and Description 
=========================
Role Name: Kubernetes-init

This Role ensures that every managed host is configured for the following requirements:

1. Yum Local Repo
2. SELinux set to Permissive
3. Firewall is Disabled
4. No Swap is on the system
5. Modify /etc/hosts
6. Install CRI-O 
7. Install Kubelet Kubectl Kubeadm
8. Install HAProxy on a dedicated host
9. Install NFS-Server on a dedicated host
10. Initiate Master-node

Requirements
------------
***********************************************************************************************************
** It is required to put the "inventories" directory outside the role in your ansible project directory! **
***********************************************************************************************************

- community.general collection installed.
- moving inventories directory outside the role.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.


Variables are mainly defined in:
--------------------------------

vars/main.yml
inventories/host_vars
inventories/group_vars

**** It is required to put the inventories directory outside the role in your ansible project directory! ****


--> "inventories" Directory Usage <-- 
-------------------------------------

Directory Hierarchy:
####################

inventories/
└── staging
    ├── group_vars
    │   ├── infrastructure.yaml
    │   ├── k8snodes.yaml
    │   ├── masternodes.yaml
    │   └── workernodes.yaml
    ├── hosts
    └── host_vars
        ├── myhaproxy.yaml
        ├── mymaster.yaml
        ├── mynfs.yaml
        └── myworker.yaml

-------------------------------------

hosts:
#######
[k8snodes]
mymaster
myworker
[masternodes]
mymaster
[workernodes]
myworker
[infrastructure]
mynfs
myhaproxy

-------------------------------------

group_vars/:
###########
- There are no variables defined yet in the group_vars

-------------------------------------
host_vars/:
##########

- Each host has his own variable file
- Each file contains the following variable for dynamic ip changing purposes

(EXAMPLE) Content of host_vars/mymaster.yaml
-->
   ansible_host: 192.168.9.50

-------------------------------------
Other variables are defined in the vars/main.yaml


{{ mount_point }} = Mount point of the local repository 
{{ crio_repo1 }} Source path for CRI-O Repo
{{ crio_repo2 }} = Source path for CRI-O Repo
{{ crio_repo1_path }} =  CRI-O Local Repo path
{{ crio_repo2_path }} = CRI-O Local Repo path
{{ nfs_share }} = Path of nfs exported directory and nfs mount point for other servers


Templates
---------

staging_hosts.j2 = populates list of hosts in /etc/hosts of all nodes
haproxy.j2 = configuration file of the haproxy


Files
-----
modules-k8s.conf  sysctl-k8s.conf

Contains k8s configurations on sysctl

Dependencies
------------

community.general collection

Install it using:

ansible-galaxy collection install community.general

Example Playbook
----------------
- name: Project Play
  hosts:
    - k8snodes
    - infrastructure

  roles:
    - Kubernetes-init

  pre_tasks:
    - name: Ping all hosts now
      ping:


  post_tasks:
      - name: Cluster Status
        debug:
          msg: "Cluster Implementation is Done!"
        when: inventory_hostname == 'mymaster' in groups.k8snodes


- It is adviced to use this playbook to run your role independantly.


Role Tasks
----------
- Every host has his own tasks in a specific yaml file. These tasks files are then imported into the main.yml tasks file of the role.

Tasks files used are as follow:
-->
allhoststasks.yaml  backup_main.yaml  haproxytasks.yaml  k8snodestasks.yaml  main.yaml  mastertasks.yaml  nfstasks.yaml  workertasks.yaml

Author Information
------------------
Written By:

Amr Sioufy 
Systems Engineer @ Linux-Plus Information Systems
>>>>>>> Kubernetes-init/main
