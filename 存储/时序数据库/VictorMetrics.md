# 介绍

## 1. 概述

**VictoriaMetrics** 是一个高性能、可扩展的开源 **时序数据库（Time Series Database，TSDB）**，主要用于存储和查询大规模时序数据，例如监控指标、IoT 数据、日志统计等。它兼容 **Prometheus** 的数据模型，可以直接替代或扩展 Prometheus 后端存储。

**官方文档**：https://docs.victoriametrics.com/

------

## 2. 核心特点

1. **高性能**
   - 写入吞吐量非常高，能够每秒写入数百万数据点。
   - 查询延迟低，即使面对数十亿条时间序列也能快速响应。
2. **高压缩比**
   - 使用专门的压缩算法（Time Series Compression），存储效率比原生 Prometheus 高很多。
   - 节省磁盘空间，同时保证读取效率。
3. **水平可扩展**
   - 有单机版（Single-node）和集群版（Cluster）：
     - **单机版**：部署简单，适合中小规模场景。
     - **集群版**：分片存储和复制，适合大规模、高可用需求。
4. **兼容 Prometheus**
   - 支持 Prometheus Remote Write/Read 协议，意味着现有的 Prometheus 采集器和 Grafana 可无缝使用。
5. **易用性**
   - 单个二进制文件即可运行，无需复杂依赖。
   - 支持自动压缩、数据保留策略和 TTL（Time To Live）。
6. **多租户支持**
   - 在集群版中支持多租户，适合 SaaS 场景。

------

## 3. 架构

VictoriaMetrics 有几种部署模式：

### 单机版

```
[Prometheus] -> [VictoriaMetrics Single Node] -> [Grafana]
```

- 所有数据写入、查询都在单个节点完成。
- 简单、适合小规模或测试场景。

### 集群版

```
[Prometheus] -> [VMInsert] -> [VMStorage] -> [VMSelect] -> [Grafana]
```

- **VMInsert**：负责接收写入数据。
- **VMStorage**：存储数据，分片处理。
- **VMSelect**：负责查询请求。
- 可以水平扩展节点，实现高吞吐量和高可用。

## 4. 数据模型

VictoriaMetrics 与 Prometheus 类似：

- **时间序列 = metric name + labels**
- 每个时间序列包含：
  - **timestamp**（时间戳）
  - **value**（数值）
- 例如：

```
http_requests_total{method="GET", handler="/api"}  1027  1690867200
```

- 支持 **标签索引**，可以高效按 label 查询。

------

## 5. 典型应用场景

- 大规模监控系统（Prometheus + Grafana + VictoriaMetrics）
- IoT 数据采集和分析
- 日志或事件统计
- 金融或游戏业务中的指标分析

------

## 6. 性能亮点

- 单机可写入上亿数据点/秒。
- 读写分离，查询延迟低。
- 压缩比高，存储成本低（比原生 Prometheus 高 3~10 倍）。
- 支持长期存储（多年历史数据）。



# 快速上手

注意：集群版本需要在路径上加上<vmxxxxx>/0/
即：组件/空间/
一般都是0

阅读官方文档：https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/

**关注三个组件：**

- vmstore组件：数据存储，port:8028
- vmselect组件：数据查询，port:8081
- vminsert组件：数据写入，port:8082

注意在环境内部使用的端口号不一样

## 前置检查

检查服务是否启动  ps

检查服务监听的端口号   netstat

检查防火墙是否放开端口   iptables

## 为适配promtheus，我们可以使用promQL语法

健康检查接口

https://<vmstore>:8428/health

https://<vmselect>:8481/health

https://<vminsert>:8482/health

###  1. 数据查询

#### 1.1 实时查询（Instant Query）

```
GET http://<vmselect>:8481/api/v1/query?query=up
```

#### 1.2 范围查询（Range Query）

```
GET "https://c:8481/api/v1/query_range?query=node_cpu_seconds_total&start=1700000000&end=1700003600&step=60"
```

#### 1.3 标签查询接口

VictoriaMetrics 支持查询标签信息，用于指标探索或动态面板：

1. **获取所有指标名称**：

```
GET /api/v1/label/__name__/values
```

1. **获取某个 label 的所有值**：

```
GET /api/v1/label/<label_name>/values
```

1. **获取符合某些标签选择器的时间序列**：

```
GET /api/v1/series?match[]=up{job="node"}&start=<start>&end=<end>
```

### 2. 数据导出、导入

```shell
# json
curl -H 'Accept-Encoding: gzip' http://<vminsert>:8481s/api/v1/export -d 'match={__name__!=""}' > exported_data.jsonl.gz
curl -X POST -H 'Content-Encoding: gzip' http://<vminsert>:8482/api/v1/import -T exported_data.jsonl.gz

# native为计算机二进制，效率更佳
# 导出
curl http://<vminsert>:8481/api/v1/export/native -d 'match={__name__!=""}' > exported_data.bin
# 导入
curl -X POST http://<vminsert>:8482/api/v1/import/native -T exported_data.bin
```

### 3. 数据删除

```shell
curl -X DELETE http://<vmstore>:8480/api/v1/admin/tsdb/delete_series -d '__name__="cpu_xxx"&id="~id1|id2|id3|..."'
```

阅读官方文档，删除时间序列时，删除API**不支持删除特定的时间范围,该系列只能完全删除**。 已删除时间序列的存储空间不会立即释放,而是在随后的时间内释放 **数据文件的后台合并** 。

清理数据方案：

1. 导出相关的范围时间数据A
2. 删除相关的时间序列
3. 查询时间序列是否删除成功
4. 导入范围时间序列数据A
5. 查询数据A
6. 执行强制合并

### 4. 强制合并

```shell
# 全部分区执行
curl http://victoriametrics:8428/internal/force_merge
# 只执行指定分区的合并，如2020年08月的数据
curl http://victoriametrics:8428/internal/force_merge?partition_prefix=2020_08
```









