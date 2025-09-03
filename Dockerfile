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

# 下载并安装 clewdr
RUN cd /app/clewdr && \
    # 直接下载指定的文件
    DOWNLOAD_URL="https://github.com/Xerxes-2/clewdr/releases/latest/download/clewdr-linux-x86_64.zip" && \
    echo "Download URL: ${DOWNLOAD_URL}" && \
    # 检查URL是否存在
    if ! wget --spider "${DOWNLOAD_URL}" 2>/dev/null; then \
        echo "ERROR: Download URL does not exist: ${DOWNLOAD_URL}" && \
        echo "Checking available releases..." && \
        curl -s https://api.github.com/repos/Xerxes-2/clewdr/releases/latest | grep "browser_download_url" && \
        exit 1; \
    fi && \
    # 下载 zip 格式
    echo "Downloading zip format..." && \
    wget -O clewdr.zip "${DOWNLOAD_URL}" && \
    echo "Download completed, file size: $(ls -lh clewdr.zip)" && \
    # 解压并显示内容
    echo "Extracting zip file..." && \
    unzip -l clewdr.zip && \
    unzip clewdr.zip && \
    rm -f clewdr.zip && \
    # 显示解压后的详细文件结构
    echo "=== Files after extraction ===" && \
    find /app/clewdr -type f -exec ls -la {} \; && \
    echo "=== Directory structure ===" && \
    find /app/clewdr -type d && \
    # 查找所有可能的可执行文件
    echo "=== Looking for executable files ===" && \
    find /app/clewdr -type f -executable -o -name "*clewdr*" && \
    # 尝试找到 clewdr 二进制文件
    CLEWDR_BIN=$(find /app/clewdr -name "clewdr" -type f | head -1) && \
    if [ -z "$CLEWDR_BIN" ]; then \
        echo "ERROR: No clewdr binary found!" && \
        echo "Looking for any executable files:" && \
        find /app/clewdr -type f -executable && \
        exit 1; \
    fi && \
    echo "Found clewdr binary at: $CLEWDR_BIN" && \
    # 移动到标准位置（如果需要）
    if [ "$CLEWDR_BIN" != "/app/clewdr/clewdr" ]; then \
        echo "Moving clewdr binary from $CLEWDR_BIN to /app/clewdr/clewdr" && \
        mv "$CLEWDR_BIN" /app/clewdr/clewdr; \
    fi && \
    # 设置权限并验证
    chmod +x /app/clewdr/clewdr && \
    ls -la /app/clewdr/clewdr && \
    file /app/clewdr/clewdr && \
    echo "ClewdR installation completed successfully"

# 验证可执行文件存在且可执行
RUN test -x /app/clewdr/clewdr || (echo "ClewdR binary not found or not executable" && exit 1)

# 设置环境变量
ENV PATH="/app/clewdr:${PATH}"

# 暴露端口 (ClewdR 默认端口，根据实际配置调整)
EXPOSE 8080

# 设置启动命令
CMD ["/app/clewdr/clewdr"]