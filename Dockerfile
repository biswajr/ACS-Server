FROM node:20-bookworm-slim

# Install MongoDB, Redis, supervisor
RUN apt-get update && apt-get install -y \
    mongodb-server \
    redis-server \
    supervisor \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /data/db /data/redis /var/log/supervisor

WORKDIR /app

# Clone & build GenieACS
RUN git clone https://github.com/genieacs/genieacs.git . \
    && git checkout v1.2.13 \
    && npm install \
    && npm run build

# Supervisord config
COPY supervisord.conf /etc/supervisord.conf

EXPOSE 3000 7547 7557 7567 27017 6379

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
