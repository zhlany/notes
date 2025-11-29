# vm+gafana的监控设计

**VictoriaMetrics 的 vmagent 组件可以完全替代 Prometheus 进行数据采集和写入**，这样可以简化架构并减少资源消耗。

## 使用 vmagent 替代 Prometheus 的架构

### 1. 简化后的整体架构

```mermaid
graph TB
    subgraph "数据采集层 (vmagent)"
        VA1[vmagent 1<br/>采集基础监控]
        VA2[vmagent 2<br/>采集业务监控]
        VA3[vmagent 3<br/>采集中间件监控]
    end
    
    subgraph "监控目标"
        T1[Node Exporter]
        T2[应用服务]
        T3[MySQL]
        T4[Redis]
        T5[cAdvisor]
        T6[自定义指标]
    end
    
    subgraph "数据存储层 (VictoriaMetrics)"
        VI[vminsert<br/>写入节点]
        VS1[vmstorage-1]
        VS2[vmstorage-2]
        VS3[vmstorage-3]
        VQ[vmselect<br/>查询节点]
    end
    
    subgraph "数据可视化层"
        GF[Grafana]
        AM[Alertmanager]
    end
    
    T1 --> VA1
    T2 --> VA2
    T3 --> VA3
    T4 --> VA3
    T5 --> VA1
    T6 --> VA2
    
    VA1 --> VI
    VA2 --> VI
    VA3 --> VI
    
    VI --> VS1
    VI --> VS2
    VI --> VS3
    
    VQ --> VS1
    VQ --> VS2
    VQ --> VS3
    
    GF --> VQ
    VQ --> AM
```

### 2. vmagent 详细架构

```mermaid
flowchart TD
    subgraph VA[vmagent 实例]
        SC1[Scrape Config 1<br/>targets: app1,app2]
        SC2[Scrape Config 2<br/>targets: node1,node2]
        SC3[Scrape Config 3<br/>targets: mysql1,redis1]
        
        BP1[Data Processing<br/>重命名/过滤/重标签]
        BP2[Relabeling<br/>指标过滤]
        BP3[Remote Write<br/>到VictoriaMetrics]
        
        SC1 --> BP1
        SC2 --> BP1
        SC3 --> BP1
        BP1 --> BP2
        BP2 --> BP3
    end
    
    subgraph Targets[监控目标]
        APP1[应用服务:8080/metrics]
        APP2[应用服务:8080/metrics]
        NODE1[Node Exporter:9100]
        NODE2[Node Exporter:9100]
        DB1[MySQL Exporter:9104]
        CACHE1[Redis Exporter:9121]
    end
    
    subgraph VM[VictoriaMetrics 集群]
        VI[vminsert]
        VS[vmstorage]
        VQ[vmselect]
    end
    
    APP1 --> SC1
    APP2 --> SC1
    NODE1 --> SC2
    NODE2 --> SC2
    DB1 --> SC3
    CACHE1 --> SC3
    
    BP3 --> VI
    VI --> VS
    VQ --> VS
```



### 3. vmagent 配置示例

yaml

```yaml
# vmagent.yml 配置示例
global:
  external_labels:
    cluster: 'production'
    region: 'us-east-1'

scrape_configs:
  # 采集节点指标
  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter-1:9100', 'node-exporter-2:9100']
    scrape_interval: 15s
    metrics_path: /metrics
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
      
  # 采集业务应用指标
  - job_name: 'application'
    static_configs:
      - targets: ['app1:8080', 'app2:8080', 'app3:8080']
    scrape_interval: 30s
    metrics_path: /actuator/prometheus
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
      - source_labels: [__meta_kubernetes_pod_name]
        target_label: pod

  # 采集Kubernetes指标
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)
      - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
        target_label: __address__

# 远程写入到VictoriaMetrics
remote_write:
  - url: http://vminsert:8480/insert/0/prometheus
    queue_config:
      max_samples_per_send: 10000
      capacity: 100000
      max_shards: 30
```



### 4. 优势对比

```mermaid
graph TD
    subgraph A[传统架构 Prometheus + VM]
        P1[Prometheus Server]
        P2[资源消耗高]
        P3[配置复杂]
        P4[存储冗余]
    end
    
    subgraph B[新架构 vmagent + VM]
        V1[vmagent]
        V2[轻量级]
        V3[配置简单]
        V4[无状态]
    end
    
    P1 -->|写入| VM1[VictoriaMetrics]
    V1 -->|写入| VM2[VictoriaMetrics]
    
    style V2 fill:#90EE90
    style V3 fill:#90EE90
    style V4 fill:#90EE90
```



### 5. 部署架构

```mermaid
graph TB
    subgraph K8S[Kubernetes 集群]
        subgraph "vmagent DaemonSet"
            VA1[vmagent Pod<br/>node: k8s-node-1]
            VA2[vmagent Pod<br/>node: k8s-node-2]
            VA3[vmagent Pod<br/>node: k8s-node-3]
        end
        
        subgraph "监控目标 Pods"
            APP1[App 1]
            APP2[App 2]
            APP3[App 3]
            NODE1[node-exporter]
            NODE2[node-exporter]
        end
    end
    
    subgraph VM[VictoriaMetrics 集群]
        VI[vminsert Service]
        VS1[vmstorage-1]
        VS2[vmstorage-2]
        VQ[vmselect Service]
    end
    
    subgraph "外部服务"
        GF[Grafana]
        AM[Alertmanager]
    end
    
    VA1 -->|采集| APP1
    VA1 -->|采集| NODE1
    VA2 -->|采集| APP2
    VA2 -->|采集| NODE2
    VA3 -->|采集| APP3
    
    VA1 --> VI
    VA2 --> VI
    VA3 --> VI
    
    VI --> VS1
    VI --> VS2
    
    GF --> VQ
    VQ --> VS1
    VQ --> VS2
    VQ --> AM
```

```mermaid
graph TB
    subgraph "数据采集层"
        A[应用程序]
        B[Node Exporter]
        C[cAdvisor]
        D[Kubernetes API]
        E[自定义业务指标]
    end

    subgraph "数据抓取与处理层"
        F[vmagent 1]
        G[vmagent 2]
        H[vmagent N]
    end

    subgraph "存储层 - VictoriaMetrics"
        I[VictoriaMetrics Single]
        J[VictoriaMetrics Cluster]
        K[vminsert]
        L[vmstorage 1]
        M[vmstorage 2]
        N[vmstorage N]
        O[vmselect]
    end

    subgraph "告警与规则引擎"
        P[vmalert]
        Q[Alertmanager]
    end

    subgraph "可视化层"
        R[Grafana]
        S[Web UI]
    end

    A & B & C & D & E --> F & G & H
    F & G & H --> I
    F & G & H --> K
    K --> L & M & N
    L & M & N --> O
    I & O --> P
    P --> Q
    I & O --> R
    I --> S
    
    style I fill:#ffebcc
    style J fill:#ffebcc
    style R fill:#ccffcc
```



## 关键优势

1. **资源效率**: vmagent 比完整 Prometheus 节省 5-10 倍内存
2. **简化架构**: 减少组件数量，降低运维复杂度
3. **无状态设计**: vmagent 可以轻松水平扩展
4. **相同配置**: 使用与 Prometheus 相同的 scrape_config 格式
5. **数据一致性**: 直接远程写入，避免数据丢失

## 迁移建议

bash

```
# 从 Prometheus 配置迁移到 vmagent
# 1. 复制 scrape_configs
# 2. 配置 remote_write 到 VictoriaMetrics
# 3. 部署 vmagent 并验证数据采集
# 4. 停用原有 Prometheus 服务器
```



使用 vmagent 替代 Prometheus 是推荐的现代化监控架构，特别适合云原生环境和大规模部署场景。