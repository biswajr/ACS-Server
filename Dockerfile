FROM node:20-alpine

# Install MongoDB, Redis, supervisord
RUN apk add --no-cache \
    mongodb-tools mongodb-server redis supervisor \
    && mkdir -p /data/db /data/redis /var/log/supervisor

WORKDIR /app

# Clone & build GenieACS (v1.2.13 stable)
RUN git clone https://github.com/genieacs/genieacs.git . \
    && git checkout v1.2.13 \
    && npm install \
    && npm run build

# Supervisord config to run Mongo + Redis + GenieACS
COPY supervisord.conf /etc/supervisord.conf

# Create directories and permissions
RUN mkdir -p /var/log/genieacs \
    && chown -R node:node /app /var/log/genieacs

# Expose ports
EXPOSE 27017 6379 3000 7547 7557 7567

# Start everything via supervisord
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
