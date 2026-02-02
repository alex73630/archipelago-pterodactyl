# Archipelago Pterodactyl Dockerfile
# Based on the official Archipelago image, adapted for Pterodactyl panel usage

ARG ARCHIPELAGO_VERSION="latest"

FROM ghcr.io/archipelagomw/archipelago:${ARCHIPELAGO_VERSION}

# Install required dependencies for Pterodactyl
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create games directory for Pterodactyl file uploads
RUN mkdir -p /games

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Set working directory
WORKDIR /app

# Pterodactyl uses this as the entrypoint
ENTRYPOINT ["/start.sh"]
