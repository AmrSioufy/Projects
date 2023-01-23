## Project repository: [Ansible Role for Installing a Kubernetes Cluster](https://github.com/AmrSioufy/Kubernetes-init) ~ https://github.com/AmrSioufy/Kubernetes-init

With Ansible being one of the leading powerful tools of infrastructure automation through day to day showcasing of its efficiency in many use cases and applications. The well-known container orchestration technology “Kubernetes” has been doing the same in its own matter; combining Ansible and Kubernetes became a common and very needed practice in today’s (cluster implementations, servers security provisioning, etc..).

This ansible role targeted 4 hosts:
- 1 master node
- 1 worker node
- NFS server
- HAProxy

The project directory hierarchy is listed below.

```
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
```
