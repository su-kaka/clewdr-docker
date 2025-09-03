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

# 步骤1：下载 clewdr zip 文件
RUN cd /app && \
    echo "Step 1: Downloading clewdr..." && \
    wget -O clewdr.zip "https://github.com/Xerxes-2/clewdr/releases/latest/download/clewdr-linux-x86_64.zip" && \
    echo "Download completed successfully" && \
    ls -la clewdr.zip

# 步骤2：解压 zip 文件
RUN cd /app && \
    echo "Step 2: Extracting zip file..." && \
    unzip clewdr.zip && \
    echo "Extraction completed" && \
    ls -la /app/

# 步骤3：进入目录并设置权限
RUN cd /app/clewdr && \
    echo "Step 3: Setting permissions..." && \
    chmod +x clewdr && \
    echo "Permissions set" && \
    ls -la /app/clewdr/

# 步骤4：清理和验证
RUN rm -f /app/clewdr.zip && \
    echo "Step 4: Final verification..." && \
    ls -la /app/clewdr/ && \
    file /app/clewdr/clewdr

# 验证可执行文件存在且可执行
RUN test -x /app/clewdr/clewdr || (echo "ClewdR binary not found or not executable" && exit 1)

# 设置环境变量
ENV PATH="/app/clewdr:${PATH}"

# 暴露端口 (ClewdR 默认端口，根据实际配置调整)
EXPOSE 8080

# 设置启动命令
CMD ["/app/clewdr/clewdr"]