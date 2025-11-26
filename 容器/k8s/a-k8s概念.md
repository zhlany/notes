# 架构概念

[Kubernetes 官方文档](https://kubernetes.io/zh-cn/docs/tasks/tools/)

学习使用：minikube 是本地 Kubernetes，专注于简化学习和开发 Kubernetes。

## 组件

### 控制平面组件

- 资源调度，检测相应集群事件等

#### kube-apiserver

- API 服务器，公开了 Kubernetes API
- 可多实例拓展

#### etcd

- 高可用键值存储

#### kube-scheduler

- 监视新创建的、未指定运行节点的 pod，选择节点让 pod 运行

#### kube-controller-manager

- 负责运行控制器进程
- 控制器类型：
  - Node 控制器 负责在节点出现故障时进行通知和响应
  - Job 控制器 监测代表一次性任务的 Job 对象，然后创建 Pod 来运行这些任务直至完成
  - EndpointSlice 控制器 填充 EndpointSlice 对象（以提供 Service 和 Pod 之间的链接）
  - ServiceAccount 控制器 为新的命名空间创建默认的 ServiceAccount

#### cloud-controller-manager (云控制器管理器)

- 少用，不阐述...

### 节点组件

- 每个节点上运行，负责维护运行的 Pod 并提供 Kubernetes 运行时环境

#### kubelet

- 每个节点（node）上运行，保证容器（containers）都运行在 Pod 中
- 接收一组通过各类机制提供给它的 PodSpec，确保这些 PodSpec 中描述的容器处于运行状态且健康。kubelet 不会管理不是由 Kubernetes 创建的容器。

#### kube-proxy（可选）

- 网络代理，实现 Kubernetes 服务（Service）概念的一部分
- 维护节点上的一些网络规则，这些网络规则会允许从集群内部或外部的网络会话与 Pod 进行网络通信。
- 如果使用网络插件为 Service 实现本身的数据包转发，并提供与 kube-proxy 等效的行为，那么你不需要在集群中的节点上运行 kube-proxy。

#### 容器运行时

- 使 Kubernetes 能够有效运行容器。它负责管理 Kubernetes 环境中容器的执行和生命周期。

### 插件（Addons）

- 插件使用 Kubernetes 资源（DaemonSet、Deployment 等）实现集群功能。因为这些插件提供集群级别的功能，插件中命名空间域的资源属于 kube-system 命名空间。

#### DNS

- 几乎所有 Kubernetes 集群都应该有集群 DNS，因为很多示例都需要 DNS 服务。
- Kubernetes 启动的容器自动将此 DNS 服务器包含在其 DNS 搜索列表中。

#### Web 界面（仪表盘）

- Dashboard 是 Kubernetes 集群的通用的、基于 Web 的用户界面。它使用户可以管理集群中运行的应用程序以及集群本身，并进行故障排除。

#### 容器资源监控

- 容器资源监控将关于容器的一些常见的时序度量值保存到一个集中的数据库中，并提供浏览这些数据的界面。

#### 集群层面日志

- 集群层面日志机制负责将容器的日志数据保存到一个集中的日志存储中，这种集中日志存储提供搜索和浏览接口。

#### 网络插件

- 网络插件是实现容器网络接口（CNI）规范的软件组件。它们负责为 Pod 分配 IP 地址，并使这些 Pod 能在集群内部相互通信。

### 架构变种

虽然 Kubernetes 的核心组件保持一致，但它们的部署和管理方式可能有所不同

#### 部署选项

##### 传统部署

- 控制平面组件直接在专用机器或虚拟机上运行，通常作为 systemd 服务进行管理。

###### 静态 Pod

- 控制平面组件作为静态 Pod 部署，由特定节点上的 kubelet 管理。这是像 kubeadm 这样的工具常用的方法。

###### 自托管

- 控制平面在 Kubernetes 集群本身内部作为 Pod 运行，由 Deployments、StatefulSets 或其他 Kubernetes 原语管理。

###### 托管 Kubernetes 服务

- 云平台通常将控制平面抽象出来，将其组件作为其服务的一部分进行管理。

## k8s对象

### 对象管理

| 管理技术       | 作用于   | 建议的环境 | 支持的写者 | 学习难度 |
| -------------- | -------- | ---------- | ---------- | -------- |
| 指令式命令     | 活跃对象 | 开发项目   | 1+         | 最低     |
| 指令式对象配置 | 单个文件 | 生产项目   | 1          | 中等     |
| 声明式对象配置 | 文件目录 | 生产项目   | 1+         | 最高     |

1. 指令式命令（推荐）👍

   - 用户可以在集群中的活动对象上进行操作

   - 例：创建 Deployment 对象来运行 nginx 容器

     ```shell
     kubectl create deployment nginx --image nginx
     ```

     

2. 指令式对象配置

   - `replace` 指令式命令将现有规范替换为新提供的规范，并放弃对配置文件中 缺少的对象的所有更改

   - 覆盖活动配置来更新配置文件中定义的对象

     ```shell
     kubectl replace -f nginx.yaml
     ```

     

3. 声明式对象配置（推荐）👍

   - 使用声明式对象配置时，用户对本地存储的对象配置文件进行操作，但是用户 未定义要对该文件执行的操作。 `kubectl` 会自动检测每个文件的创建、更新和删除操作。 这使得**配置可以在目录上工作，根据目录中配置文件对不同的对象执行不同的操作**。

   - 处理 `configs` 目录中的所有对象配置文件，创建并更新活跃对象。 可以首先使用 `diff` 子命令查看将要进行的更改，然后在进行应用：

     ```sh
     kubectl diff -R -f configs/
     kubectl apply -R -f configs/
     ```

### 标签

**标签（Labels）** 是附加到 Kubernetes [对象](https://kubernetes.io/zh-cn/docs/concepts/overview/working-with-objects/#kubernetes-objects)（比如 Pod）上的键值对。标签可以在创建时附加到对象，随后可以随时添加和修改

```json
"metadata": {
  "labels": {
    "key1" : "value1",
    "key2" : "value2"
  }
}
```

### **名字空间（Namespace）**

​	在 Kubernetes 中，**名字空间（Namespace）** 提供一种机制，将同一集群中的资源划分为相互隔离的组。 同一名字空间内的资源名称要唯一，但跨名字空间时没有这个要求。 名字空间作用域仅针对带有名字空间的[对象](https://kubernetes.io/zh-cn/docs/concepts/overview/working-with-objects/#kubernetes-objects)， （例如 Deployment、Service 等），这种作用域对集群范围的对象 （例如 StorageClass、Node、PersistentVolume 等）不适用。

#### 初始名字空间

Kubernetes 启动时会创建四个初始名字空间：

- `default`

  Kubernetes 包含这个名字空间，以便于你无需创建新的名字空间即可开始使用新集群。

- `kube-node-lease`

  该名字空间包含用于与各个节点关联的 [Lease（租约）](https://kubernetes.io/zh-cn/docs/concepts/architecture/leases/)对象。 节点租约允许 kubelet 发送[心跳](https://kubernetes.io/zh-cn/docs/concepts/architecture/nodes/#node-heartbeats)， 由此控制面能够检测到节点故障。

- `kube-public`

  **所有**的客户端（包括未经身份验证的客户端）都可以读取该名字空间。 该名字空间主要预留为集群使用，以便某些资源需要在整个集群中可见可读。 该名字空间的公共属性只是一种约定而非要求。

- `kube-system`

  该名字空间用于 Kubernetes 系统创建的对象。

#### 查看名字空间

```shell
kubectl get namespace
```

#### 为请求设置名字空间

```shell
kubectl run nginx --image=nginx --namespace=<名字空间名称>
kubectl get pods --namespace=<名字空间名称>
```

### 注解

使用 Kubernetes 注解为[对象](https://kubernetes.io/zh-cn/docs/concepts/overview/working-with-objects/#kubernetes-objects)附加任意的非标识的元数据。 客户端程序（例如工具和库）能够获取这些元数据信息。

```json
"metadata": {
  "annotations": {
    "key1" : "value1",
    "key2" : "value2"
  }
}
```

#### 字段选择算符

将筛选出 [`status.phase`](https://kubernetes.io/zh-cn/docs/concepts/workloads/pods/pod-lifecycle/#pod-phase) 字段值为 `Running` 的所有 Pod：

```shell
kubectl get pods --field-selector status.phase=Running
```

#### 支持的字段列表

| 类别                      | 字段                                                         |
| ------------------------- | ------------------------------------------------------------ |
| Pod                       | `spec.nodeName` `spec.restartPolicy` `spec.schedulerName` `spec.serviceAccountName` `spec.hostNetwork` `status.phase` `status.podIP` `status.podIPs` `status.nominatedNodeName` |
| Event                     | `involvedObject.kind` `involvedObject.namespace` `involvedObject.name` `involvedObject.uid` `involvedObject.apiVersion` `involvedObject.resourceVersion` `involvedObject.fieldPath` `reason` `reportingComponent` `source` `type` |
| Secret                    | `type`                                                       |
| Namespace                 | `status.phase`                                               |
| ReplicaSet                | `status.replicas`                                            |
| ReplicationController     | `status.replicas`                                            |
| Job                       | `status.successful`                                          |
| Node                      | `spec.unschedulable`                                         |
| CertificateSigningRequest | `spec.signerName`                                            |

### 推荐使用的标签

- 一组通用的标签可以让多个工具之间相互操作，用所有工具都能理解的通用方式描述对象。
- 推荐的标签。它们使管理应用程序变得更容易
- **共享标签和注解都使用同一个前缀**：`app.kubernetes.io`。没有前缀的标签是用户私有的。 共享前缀可以确保共享标签不会干扰用户自定义的标签。

#### 标签

为了充分利用这些标签，应该在每个资源对象上都使用它们。

| 键                             | 描述                                                         | 示例           | 类型   |
| ------------------------------ | ------------------------------------------------------------ | -------------- | ------ |
| `app.kubernetes.io/name`       | 应用程序的名称                                               | `mysql`        | 字符串 |
| `app.kubernetes.io/instance`   | 用于唯一确定应用实例的名称                                   | `mysql-abcxyz` | 字符串 |
| `app.kubernetes.io/version`    | 应用程序的当前版本（例如[语义版本 1.0](https://semver.org/spec/v1.0.0.html)、修订版哈希等） | `5.7.21`       | 字符串 |
| `app.kubernetes.io/component`  | 架构中的组件                                                 | `database`     | 字符串 |
| `app.kubernetes.io/part-of`    | 此级别的更高级别应用程序的名称                               | `wordpress`    | 字符串 |
| `app.kubernetes.io/managed-by` | 用于管理应用程序的工具                                       | `Helm`         | 字符串 |

示例

为了说明使用这些标签的不同方式，以下示例具有不同的复杂性。

##### 一个简单的无状态服务

考虑使用 `Deployment` 和 `Service` 对象部署的简单无状态服务的情况。 以下两个代码段表示如何以最简单的形式使用标签。

下面的 `Deployment` 用于监督运行应用本身的那些 Pod。

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/name: myservice
    app.kubernetes.io/instance: myservice-abcxyz
...
```

下面的 `Service` 用于暴露应用。

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/name: myservice
    app.kubernetes.io/instance: myservice-abcxyz
...
```

##### 带有一个数据库的 Web 应用程序

考虑一个稍微复杂的应用：一个使用 Helm 安装的 Web 应用（WordPress）， 其中使用了数据库（MySQL）。以下代码片段说明用于部署此应用程序的对象的开始。

以下 `Deployment` 的开头用于 WordPress：

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/name: wordpress
    app.kubernetes.io/instance: wordpress-abcxyz
    app.kubernetes.io/version: "4.9.4"
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: server
    app.kubernetes.io/part-of: wordpress
...
```

这个 `Service` 用于暴露 WordPress：

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/name: wordpress
    app.kubernetes.io/instance: wordpress-abcxyz
    app.kubernetes.io/version: "4.9.4"
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: server
    app.kubernetes.io/part-of: wordpress
...
```

MySQL 作为一个 `StatefulSet` 暴露，包含它和它所属的较大应用程序的元数据：

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  labels:
    app.kubernetes.io/name: mysql
    app.kubernetes.io/instance: mysql-abcxyz
    app.kubernetes.io/version: "5.7.21"
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: database
    app.kubernetes.io/part-of: wordpress
...
```

`Service` 用于将 MySQL 作为 WordPress 的一部分暴露：

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/name: mysql
    app.kubernetes.io/instance: mysql-abcxyz
    app.kubernetes.io/version: "5.7.21"
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: database
    app.kubernetes.io/part-of: wordpress
...
```

使用 MySQL `StatefulSet` 和 `Service`，你会注意到有关 MySQL 和 WordPress 的信息，包括更广泛的应用程序。
