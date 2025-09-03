# 使用最新的 Debian 作为基础镜像
FROM debian:latest

# 设置工作目录
WORKDIR /app

# 复制代码
COPY . .

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

# 下载并安装 clewdr
RUN cd /app && \
    echo "Downloading clewdr..." && \
    wget -O clewdr.zip "https://github.com/Xerxes-2/clewdr/releases/latest/download/clewdr-musllinux-x86_64.zip" && \
    echo "Extracting..." && \
    unzip clewdr.zip && \
    echo "Setting permissions..." && \
    chmod +x clewdr/clewdr && \
    echo "Cleaning up..." && \
    rm -f clewdr.zip && \
    echo "Installation completed" && \
    ls -la /app/clewdr/

# 验证可执行文件存在且可执行
RUN test -x /app/clewdr/clewdr || (echo "ClewdR binary not found or not executable" && exit 1)

# 设置环境变量
ENV PATH="/app/clewdr:${PATH}"

# 暴露端口 (ClewdR 默认端口，根据实际配置调整)
EXPOSE 8080

# 设置启动命令
CMD ["/app/clewdr/clewdr"]