# VictoriaMetrics+Prometheus+Grafana的监控系统架构

## 系统架构设计

### 1. 整体架构图

```mermaid
graph TB
    subgraph "数据采集层"
        A1[应用服务]
        A2[中间件]
        A3[操作系统]
        A4[Kubernetes]
        
        P1[Prometheus Server]
        P2[Prometheus Server]
    end
    
    subgraph "数据存储层"
        VM[VictoriaMetrics Cluster<br/>vmstorage × 3]
        VMS1[vmselect]
        VMS2[vminsert]
    end
    
    subgraph "数据可视化层"
        G1[Grafana]
        G2[Grafana]
    end
    
    subgraph "告警管理"
        AM[Alertmanager]
        AR[Alert Router]
    end
    
    A1 -->|metrics| P1
    A2 -->|metrics| P1
    A3 -->|metrics| P2
    A4 -->|metrics| P2
    
    P1 -->|remote_write| VMS2
    P2 -->|remote_write| VMS2
    
    VMS2 --> VM
    VMS1 --> VM
    
    G1 -->|查询| VMS1
    G2 -->|查询| VMS1
    
    VMS1 -->|告警规则| AM
    AM --> AR
    AR -->|邮件/钉钉/微信| US[用户]
```

### 2. 详细组件交互图

```mermaid
flowchart TD
    subgraph "Targets 监控目标"
        N1[Node Exporter]
        N2[cAdvisor]
        N3[应用业务指标]
        N4[MySQL Exporter]
        N5[Redis Exporter]
    end
    
    subgraph "Prometheus 采集集群"
        P1[Prometheus Server 1<br/>负责基础监控]
        P2[Prometheus Server 2<br/>负责业务监控]
        P3[Prometheus Server 3<br/>负责中间件监控]
    end
    
    subgraph "VictoriaMetrics 集群"
        subgraph "写入节点"
            VI1[vminsert-1]
            VI2[vminsert-2]
        end
        
        subgraph "存储节点"
            VS1[vmstorage-1]
            VS2[vmstorage-2]
            VS3[vmstorage-3]
        end
        
        subgraph "查询节点"
            VQ1[vmselect-1]
            VQ2[vmselect-2]
        end
    end
    
    subgraph "监控展示"
        GF[Grafana<br/>数据可视化]
        AL[Alertmanager<br/>告警管理]
    end
    
    N1 --> P1
    N2 --> P1
    N3 --> P2
    N4 --> P3
    N5 --> P3
    
    P1 -->|remote_write| VI1
    P2 -->|remote_write| VI1
    P3 -->|remote_write| VI2
    
    VI1 --> VS1
    VI1 --> VS2
    VI1 --> VS3
    VI2 --> VS1
    VI2 --> VS2
    VI2 --> VS3
    
    VQ1 --> VS1
    VQ1 --> VS2
    VQ1 --> VS3
    VQ2 --> VS1
    VQ2 --> VS2
    VQ2 --> VS3
    
    GF -->|PromQL查询| VQ1
    GF -->|PromQL查询| VQ2
    
    VQ1 -->|告警评估| AL
    VQ2 -->|告警评估| ALs
```

### 3. 数据流序列图

```mermaid
sequenceDiagram
    participant T as 监控目标
    participant P as Prometheus
    participant VI as vminsert
    participant VS as vmstorage
    participant VQ as vmselect
    participant G as Grafana
    participant A as Alertmanager
    
    Note over T, A: 数据采集与写入流程
    T->>P: 暴露/metrics端点
    P->>P: 定时抓取指标数据
    P->>VI: remote_write推送数据
    VI->>VS: 分布式存储数据
    VS-->>VI: 存储确认
    
    Note over T, A: 数据查询与展示流程
    G->>VQ: 发送PromQL查询请求
    VQ->>VS: 从各storage节点获取数据
    VS-->>VQ: 返回查询结果
    VQ->>VQ: 聚合和计算数据
    VQ-->>G: 返回最终结果
    G->>G: 数据可视化渲染
    
    Note over T, A: 告警处理流程
    VQ->>VQ: 定期评估告警规则
    VQ->>A: 触发告警事件
    A->>A: 分组、去重、静默
    A->>A: 路由到对应接收器
    A->>A: 发送告警通知
```

## 关键配置说明

### Prometheus 远程写入配置

```yaml
remote_write:
  - url: http://vminsert:8480/insert/0/prometheus
    queue_config:
      capacity: 10000
      max_shards: 30
      min_shards: 1
      max_samples_per_send: 1000
```

### VictoriaMetrics 集群配置

- **vmstorage**: 数据存储，可水平扩展
- **vminsert**: 数据写入，无状态可扩展
- **vmselect**: 数据查询，无状态可扩展

### Grafana 数据源配置

```yaml
datasources:
  - name: VictoriaMetrics
    type: prometheus
    url: http://vmselect:8481/select/0/prometheus
    access: proxy
```

这种架构提供了高可用性、水平扩展能力和优异的查询性能，适合大规模监控场景。