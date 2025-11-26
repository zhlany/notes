```ini
[mysqld]
# 字符集配置
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci

# 性能优化
innodb_buffer_pool_size=256M
max_connections=100

# 日志配置
slow_query_log=1
slow_query_log_file=/var/lib/mysql/slow.log
long_query_time=2
```

