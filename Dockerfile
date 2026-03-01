FROM node:20-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git python3 make g++

WORKDIR /app

# Clone specific version and build
RUN git clone https://github.com/genieacs/genieacs.git . \
    && git checkout v1.2.13 \
    && npm install \
    && npm run build

# Final runtime image
FROM node:20-alpine

# Install runtime deps + supervisord
RUN apk add --no-cache supervisor

WORKDIR /app

# Copy built app from builder stage
COPY --from=builder /app /app

# Create log dir
RUN mkdir -p /var/log/supervisor

# Supervisord config to run all services
COPY supervisord.conf /etc/supervisord.conf

# Expose all GenieACS ports
EXPOSE 3000 7547 7557 7567

# Run supervisord (non-daemon mode for Docker)
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
