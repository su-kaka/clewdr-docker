FROM debian:latest

WORKDIR /app

# 复制默认二进制文件到临时位置
COPY clewdr /tmp/clewdr-default
RUN chmod +x /tmp/clewdr-default

ENV CLEWDR_IP=0.0.0.0

EXPOSE 8484

# 启动时检查：如果卷里没有二进制文件，则复制默认版本，不覆盖现有文件
CMD if [ ! -f "/app/clewdr" ]; then echo "No clewdr found in volume, copying default version" && cp /tmp/clewdr-default /app/clewdr; else echo "Using existing clewdr from mounted volume"; fi && chmod +x /app/clewdr && exec /app/clewdr