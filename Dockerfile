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
    wget -O clewdr.zip "https://github.com/Xerxes-2/clewdr/releases/latest/download/clewdr-linux-x86_64.zip" && \
    echo "Extracting..." && \
    unzip clewdr.zip && \
    echo "Checking extracted files..." && \
    ls -la && \
    find . -name "*clewdr*" -type f && \
    echo "Setting permissions..." && \
    chmod +x */clewdr 2>/dev/null || chmod +x clewdr 2>/dev/null || (echo "Finding clewdr binary..." && find . -name "clewdr" -type f -exec chmod +x {} \;) && \
    echo "Cleaning up..." && \
    rm -f clewdr.zip && \
    echo "Installation completed"

# 验证可执行文件存在且可执行
RUN find /app -name "clewdr" -type f -executable | head -1 | xargs -I {} test -x {} || (echo "ClewdR binary not found or not executable" && exit 1)

# 找到clewdr可执行文件并创建符号链接
RUN CLEWDR_PATH=$(find /app -name "clewdr" -type f -executable | head -1) && \
    if [ -n "$CLEWDR_PATH" ]; then \
        ln -sf "$CLEWDR_PATH" /usr/local/bin/clewdr && \
        echo "ClewdR linked to: $CLEWDR_PATH"; \
    else \
        echo "ClewdR binary not found" && exit 1; \
    fi

# 暴露端口 (ClewdR 默认端口，根据实际配置调整)
EXPOSE 8080

# 设置启动命令
CMD ["clewdr"]