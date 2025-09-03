# ClewdR Docker

ClewdR 的 Docker 容器化部署方案

## 快速开始

### 使用 Docker Compose（推荐）

1. 下载 docker-compose.yml 文件
2. 运行容器：

```bash
docker-compose up -d
```

### 使用 Docker 命令

```bash
docker run -d \
  --name clewdr \
  --restart unless-stopped \
  -p 8484:8484 \
  -v ./clewdr:/app \
  -e CLEWDR_IP=0.0.0.0 \
  ghcr.io/su-kaka/clewdr-docker:latest
```

## 配置说明

### 环境变量

- `CLEWDR_IP`: 服务绑定的IP地址，默认为 `0.0.0.0`（允许外部访问）

### 端口

- `8484`: ClewdR 默认端口

### 数据持久化

容器会挂载 `./clewdr` 目录到容器内的 `/app` 目录：

- 如果挂载目录中存在 `clewdr` 二进制文件，容器将优先使用该文件
- 如果不存在，容器将使用内置的默认版本, 并复制一份到挂载目录中
- 配置文件和数据文件也会保存在这个目录中

## 升级

### 升级容器版本

```bash
docker-compose pull
docker-compose up -d
```

### 升级 ClewdR 二进制

在clewdr里面打开自动更新，然后重启即可

```bash
docker-compose restart
```

## 故障排除

### 查看日志

```bash
docker-compose logs -f
```

### 检查容器状态

```bash
docker-compose ps
```

### 重置配置

删除挂载目录中的文件并重启容器。

## 构建说明

本镜像支持：
- 自动检测挂载卷中的 ClewdR 二进制文件
- 如果挂载卷中没有二进制文件，使用内置默认版本
- 自动设置文件权限
- 灵活的网络配置