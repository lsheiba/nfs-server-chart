NFS Server chart
================

Original containerized solution here: [Dockerized NFS Server](11)

## Docker registry

Automated build repository https://hub.docker.com/r/monstar/nfs-server/, builds on every push to `master` in current repository.

## Install chart

Install:
```
$ helm install ./chart
NAME:   boisterous-monkey
LAST DEPLOYED: Fri Apr 14 19:34:18 2017
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Service
NAME        CLUSTER-IP    EXTERNAL-IP  PORT(S)           AGE
nfs-server  10.0.183.122  <none>       2049/TCP,111/TCP  1s

==> extensions/v1beta1/Deployment
NAME        DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
nfs-server  1        1        1           0          1s
```

And check:
```
$ kubectl get deploy,po,service
NAME                DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/nfs-server   1         1         1            1           27s

NAME                             READY     STATUS    RESTARTS   AGE
po/nfs-server-2986952916-u0km4   1/1       Running   0          27s

NAME             CLUSTER-IP     EXTERNAL-IP   PORT(S)            AGE
svc/nfs-server   10.0.183.122   <none>        2049/TCP,111/TCP   27s
```

Or install just a deployment:
```
$ kubectl create -f nfs-deploy.yaml
deployment "nfs-server" created
```

Get NFS-server pod's IP:
```
$ kubectl describe po nfs-server-2986952916-u0km4 | grep IP | sed -E 's/IP:[[:space:]]+//'
10.244.2.118
```

## Check connection to NFS

Start Ubuntu and go to shell:
```
$ kubectl create -f test/nfs-client.yaml
deployment "nfs-client" created

$ kubectl get po
NAME                          READY     STATUS    RESTARTS   AGE
nfs-client-1714487185-m6s5y   1/1       Running   0          53s
nfs-server-2986952916-u0km4   1/1       Running   0          1h

$ kubectl exec -it nfs-client-1714487185-m6s5y bash
```

Make target dir:
```
# mkdir /mnt/target_dir
```

Mount NFS entry point:
```
# mount -v -t nfs -o proto=tcp,port=2049 10.244.2.118:/exports /mnt/target_dir
```

Create somefile on client:
```
# cd /mnt/target_dir
# touch test
```

Go to server and sure that file `test` is in `/export` directory.