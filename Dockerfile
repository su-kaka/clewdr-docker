# 使用最新的 Debian 作为基础镜像
FROM debian:latest

# 设置工作目录
WORKDIR /app

# 更新包管理器并安装必要的工具
RUN apt-get update && \
    apt-get install -y \
        wget \
        curl \
        unzip \
        ca-certificates \
        file \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 创建 clewdr 目录
RUN mkdir -p /app/clewdr

# 设置架构变量和平台映射
ARG TARGETARCH
ARG TARGETPLATFORM

# 根据 Docker 的架构变量映射到 clewdr 的命名约定
RUN case "${TARGETARCH}" in \
        "amd64") export CLEWDR_ARCH="x86_64" ;; \
        "arm64") export CLEWDR_ARCH="aarch64" ;; \
        "arm") export CLEWDR_ARCH="armv7" ;; \
        *) export CLEWDR_ARCH="x86_64" ;; \
    esac && \
    echo "Architecture: ${CLEWDR_ARCH}" && \
    cd /app/clewdr && \
    # 下载 zip 格式
    echo "Downloading zip format..." && \
    wget -O clewdr.zip "https://github.com/Xerxes-2/clewdr/releases/latest/download/clewdr-linux-${CLEWDR_ARCH}.zip" && \
    unzip clewdr.zip && \
    chmod +x clewdr && \
    rm -f clewdr.zip && \
    # 验证下载的文件
    ls -la /app/clewdr/ && \
    file /app/clewdr/clewdr && \
    echo "ClewdR installation completed"

# 验证可执行文件存在且可执行
RUN test -x /app/clewdr/clewdr || (echo "ClewdR binary not found or not executable" && exit 1)

# 设置环境变量
ENV PATH="/app/clewdr:${PATH}"

# 暴露端口 (ClewdR 默认端口，根据实际配置调整)
EXPOSE 8080

# 设置启动命令
CMD ["/app/clewdr/clewdr"]