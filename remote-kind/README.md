# Remote KinD cluster
Terragrunt template for running a remote KinD cluster.

You have to set the a remote docker host:
```
export KIND_REMOTE_HOST="192.168.0.42"
export KIND_REMOTE_USER="user"
```

You must have access with a pre-authorized ssh key:
```
ssh ${KIND_REMOTE_USER}@${KIND_REMOTE_HOST} docker ps
```
