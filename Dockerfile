# 使用最新的 Debian 作为基础镜像
FROM debian:latest

# 设置工作目录
WORKDIR /app

# 更新包管理器并安装必要的工具
RUN apt-get update && \
    apt-get install -y \
        wget \
        tar \
        ca-certificates \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 创建 clewdr 目录
RUN mkdir -p /app/clewdr

# 设置架构变量 (默认为 x86_64，可通过构建参数覆盖)
ARG TARGETARCH=x86_64
ARG PLATFORM=linux-${TARGETARCH}

# 下载并安装 clewdr
RUN cd /app/clewdr && \
    wget -O clewdr-${PLATFORM}.tar.gz https://github.com/Xerxes-2/clewdr/releases/latest/download/clewdr-${PLATFORM}.tar.gz && \
    tar -xzf clewdr-${PLATFORM}.tar.gz && \
    chmod +x clewdr && \
    rm -f clewdr-${PLATFORM}.tar.gz

# 创建挂载点目录
VOLUME ["/app/clewdr"]

# 设置环境变量
ENV PATH="/app/clewdr:${PATH}"

# 暴露可能需要的端口 (根据 clewdr 的实际需求调整)
EXPOSE 8080

# 设置启动命令
CMD ["/app/clewdr/clewdr"]