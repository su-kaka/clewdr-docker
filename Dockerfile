FROM debian:latest

WORKDIR /app

COPY clewdr /app/clewdr

RUN chmod +x /app/clewdr

ENV CLEWDR_IP=0.0.0.0

EXPOSE 8484

CMD ["/app/clewdr"]