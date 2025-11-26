# 该文主要记录k8s常用的命令，便于快速上手进行开发

## 一、基础核心命令



### 1.资源查看

```sh
# 查看所有命名空间的节点
kubectl get nodes

# 查看所有命名空间的 Pod
kubectl get pods -A

# 查看指定命名空间（如 default）的 Pod
kubectl get pods -n default

# 查看 Pod 的详细信息（IP、节点、事件等）
kubectl get pods -o wide

# 查看 Service
kubectl get svc -A

# 查看 Deployment
kubectl get deployments -A

# 查看 ConfigMap
kubectl get configmaps -A

# 查看 Secret
kubectl get secrets -A

# 查看所有类型的资源
kubectl get all -A

# 持续监听资源变化（类似于 watch）
kubectl get pods -w
```

### 2.创建/删除

```sh
# 使用 YAML 文件创建资源
kubectl apply -f deployment.yaml

# 使用 YAML 文件删除资源
kubectl delete -f deployment.yaml

# 直接通过资源名删除（例如删除一个 Pod）
kubectl delete pod <pod-name> -n <namespace>

# 删除一个 Deployment
kubectl delete deployment <deployment-name> -n <namespace>

# 强制删除 Pod（当普通删除卡住时）
kubectl delete pod <pod-name> --force --grace-period=0
```

### 3.查看资源详情和配置

```sh
# 查看 Pod 的详细描述信息（非常重要用于排错）
kubectl describe pod <pod-name> -n <namespace>

# 查看 Node 的详细描述
kubectl describe node <node-name>

# 查看 Service 的详细描述
kubectl describe svc <service-name>

# 查看资源的 YAML 配置
kubectl get pod <pod-name> -o yaml

# 查看并编辑资源的配置（会直接应用修改）
kubectl edit deployment <deployment-name>
```

## 二、故障排查与日志

### 1.查看日志

```sh
# 查看 Pod 的日志
kubectl logs <pod-name> -n <namespace>

# 查看 Pod 中指定容器的日志（当 Pod 有多个容器时）
kubectl logs <pod-name> -c <container-name> -n <namespace>

# 实时跟踪日志（类似于 tail -f）
kubectl logs -f <pod-name> -n <namespace>

# 查看之前崩溃的 Pod 的日志（对于 Restart 的 Pod 非常有用）
kubectl logs -p <pod-name> -n <namespace>
```

### 2.进入 Pod（执行命令）

```sh
# 在 Pod 的容器中执行命令（最常见的进入容器方式）
kubectl exec -it <pod-name> -n <namespace> -- /bin/bash
# 或者使用 sh
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh

# 在 Pod 的指定容器中执行命令（多容器场景）
kubectl exec -it <pod-name> -c <container-name> -n <namespace> -- /bin/bash

# 不进入交互模式，直接执行命令
kubectl exec <pod-name> -- ls /app
```

## 三、调试与维护

### 1. 端口转发（用于访问集群内服务）

```sh
# 将本地的 8080 端口转发到 Pod 的 80 端口
kubectl port-forward pod/<pod-name> 8080:80 -n <namespace>

# 转发到 Service
kubectl port-forward svc/<service-name> 8080:80 -n <namespace>

# 转发到 Deployment（会自动选择一个 Pod）
kubectl port-forward deployment/<deployment-name> 8080:80 -n <namespace>
```

### 2. 调试 Pod

```sh
# 创建一个临时调试 Pod（例如使用 busybox）
kubectl run debug-shell --rm -i --tty --image=busybox -- /bin/sh

# 如果 Pod 因镜像问题无法启动，可以使用一个基础镜像临时启动进行网络等测试
kubectl run test-pod --image=nginx --restart=Never
```

