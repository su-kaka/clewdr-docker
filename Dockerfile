FROM debian:latest

WORKDIR /app

# 复制默认二进制文件到临时位置
COPY clewdr /tmp/clewdr-default
RUN chmod +x /tmp/clewdr-default

ENV CLEWDR_IP=0.0.0.0

EXPOSE 8484

# 启动时检查：优先使用挂载卷中的clewdr，如果不存在则使用默认版本
CMD if [ -f "/app/clewdr" ]; then echo "Using clewdr from mounted volume" && chmod +x /app/clewdr && exec /app/clewdr; else echo "Using default clewdr" && exec /tmp/clewdr-default; fi