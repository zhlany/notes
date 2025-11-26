```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-deployment
  namespace: default
  labels:
    app: my-app
    version: v1.0.0
    environment: production
  annotations:
    deployment.kubernetes.io/revision: "1"
    description: "My application deployment configuration"
spec:
  # 副本数量
  replicas: 3
  
  # 选择器，用于匹配 Pod
  selector:
    matchLabels:
      app: my-app
      component: api
  
  # 策略配置
  strategy:
    type: RollingUpdate  # 也可以是 Recreate
    rollingUpdate:
      maxSurge: 1        # 更新过程中可以超过期望 Pod 数量的最大值（可以是数字或百分比）
      maxUnavailable: 0  # 更新过程中不可用 Pod 的最大数量（可以是数字或百分比）
  
  # 最小就绪时间（可选）
  minReadySeconds: 30
  
  # 修订历史限制
  revisionHistoryLimit: 10
  
  # 进度期限秒数
  progressDeadlineSeconds: 600
  
  # Pod 模板
  template:
    metadata:
      labels:
        app: my-app
        component: api
        version: v1.0.0
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "8080"
        prometheus.io/path: "/metrics"
    spec:
      # 重启策略
      restartPolicy: Always
      
      # 终止宽限期（秒）
      terminationGracePeriodSeconds: 30
      
      # 亲和性配置
      affinity:
        # Pod 亲和性 - 倾向于与某些 Pod 一起调度
        podAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: app
                  operator: In
                  values:
                  - my-app
              topologyKey: kubernetes.io/hostname
        
        # Pod 反亲和性 - 避免与某些 Pod 一起调度
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: app
                  operator: In
                  values:
                  - my-app
              topologyKey: kubernetes.io/hostname
        
        # 节点亲和性
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 1
            preference:
              matchExpressions:
              - key: disktype
                operator: In
                values:
                - ssd
      
      # 节点选择器
      nodeSelector:
        node-type: high-cpu
      
      # 容忍度
      tolerations:
      - key: "dedicated"
        operator: "Equal"
        value: "gpu"
        effect: "NoSchedule"
      - key: "spot-instance"
        operator: "Exists"
        effect: "NoExecute"
        tolerationSeconds: 3600
      
      # 容器配置
      containers:
      - name: my-app
        image: my-registry/my-app:v1.0.0
        imagePullPolicy: IfNotPresent
        
        # 端口配置
        ports:
        - name: http
          containerPort: 8080
          protocol: TCP
        - name: metrics
          containerPort: 9090
          protocol: TCP
        
        # 环境变量
        env:
        - name: APP_ENV
          value: "production"
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: connection-string
        - name: CONFIG_MAP_VALUE
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: api-endpoint
        - name: POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        - name: NODE_NAME
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName
        
        # 资源限制
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        
        # 存活探针
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 3
        
        # 就绪探针
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 5
          periodSeconds: 5
          timeoutSeconds: 3
          successThreshold: 1
          failureThreshold: 3
        
        # 启动探针（K8s 1.16+）
        startupProbe:
          httpGet:
            path: /startup
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 10
          periodSeconds: 5
          timeoutSeconds: 3
          successThreshold: 1
          failureThreshold: 30
        
        # 生命周期钩子
        lifecycle:
          postStart:
            exec:
              command: ["/bin/sh", "-c", "echo 'Container started' > /tmp/startup.log"]
          preStop:
            exec:
              command: ["/bin/sh", "-c", "sleep 10; echo 'Graceful shutdown'"]
        
        # 安全上下文
        securityContext:
          runAsNonRoot: true
          runAsUser: 1000
          runAsGroup: 1000
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          readOnlyRootFilesystem: true
        
        # 卷挂载
        volumeMounts:
        - name: config-volume
          mountPath: /etc/config
          readOnly: true
        - name: temporary-storage
          mountPath: /tmp
        - name: shared-data
          mountPath: /app/data
      
      # 初始化容器
      initContainers:
      - name: init-db
        image: busybox:1.28
        command: ['sh', '-c', 'until nslookup my-database; do echo waiting for database; sleep 2; done']
      - name: init-config
        image: busybox:1.28
        command: ['sh', '-c', 'cp /tmp/config/* /shared-config/']
        volumeMounts:
        - name: config-script
          mountPath: /tmp/config
        - name: shared-config
          mountPath: /shared-config
      
      # 服务账户
      serviceAccountName: my-app-service-account
      automountServiceAccountToken: true
      
      # 镜像拉取密钥
      imagePullSecrets:
      - name: my-registry-secret
      
      # 主机别名
      hostAliases:
      - ip: "192.168.1.100"
        hostnames:
        - "api.internal"
        - "db.internal"
      
      # DNS 配置
      dnsConfig:
        nameservers:
        - 8.8.8.8
        searches:
        - ns1.svc.cluster-domain.example
        - my.dns.search.suffix
        options:
        - name: ndots
          value: "2"
        - name: edns0
      
      # 卷配置
      volumes:
      - name: config-volume
        configMap:
          name: app-config
          items:
          - key: config.yml
            path: config.yml
      - name: temporary-storage
        emptyDir: {}
      - name: shared-data
        persistentVolumeClaim:
          claimName: my-app-pvc
      - name: config-script
        secret:
          secretName: init-script
      - name: shared-config
        emptyDir: {}
      
      # 安全上下文（Pod 级别）
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        runAsGroup: 1000
        fsGroup: 1000
        seccompProfile:
          type: RuntimeDefault
      
      # 主机网络（谨慎使用）
      hostNetwork: false
      
      # 主机 PID 命名空间
      hostPID: false
      
      # 主机 IPC 命名空间
      hostIPC: false
      
      # 调度器名称
      schedulerName: default-scheduler
      
      # 优先级
      priorityClassName: high-priority
```

