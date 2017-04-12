NFS Server chart
================

Original containerized solution here: [Dockerized NFS Server](https://github.com/ErezHorev/dockerized_nfs_server)

## Docker registry

Automated build repository https://hub.docker.com/r/monstar/nfs-server/, builds on every push to `master` in current repository.

## Install chart

Install:

```
$ helm install ./chart
NAME:   bailing-poodle
LAST DEPLOYED: Wed Apr 12 16:27:25 2017
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Service
NAME                CLUSTER-IP   EXTERNAL-IP  PORT(S)           AGE
nfs-server-service  10.0.34.165  <none>       111/TCP,2049/TCP  1s

==> extensions/v1beta1/Deployment
NAME                   DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
nfs-server-deployment  1        1        1           0          1s
```

And check:

```
$ kubectl get deploy,po,service
NAME                           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/nfs-server-deployment   1         1         1            1           53s

NAME                                        READY     STATUS    RESTARTS   AGE
po/nfs-server-deployment-3595847892-466r6   1/1       Running   0          53s

NAME                     CLUSTER-IP    EXTERNAL-IP   PORT(S)            AGE
svc/nfs-server-service   10.0.34.165   <none>        111/TCP,2049/TCP   53s
```

## Try to check NFS

Install Ubuntu
```
$ kubectl run test --image=nginx
```
Go to console:
```
$ kubectl get po
NAME                                     READY     STATUS    RESTARTS   AGE
test-2959316856-z3frz                    1/1       Running   0          35s
```
```
$ kubectl exec -it test-2959316856-z3frz bash
```
Install NFS client:
```
# apt-get update
# apt-get -y install nfs-common portmap
```
And setup it:
```
# mkdir -p /mnt/nfs/exports
# mount 10.0.34.165:/exports /mnt/nfs/exports
```
