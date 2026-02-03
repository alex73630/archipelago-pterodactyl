# Archipelago Pterodactyl Dockerfile
# Based on the official Archipelago image, adapted for Pterodactyl panel usage

ARG ARCHIPELAGO_VERSION="latest"

FROM ghcr.io/archipelagomw/archipelago:${ARCHIPELAGO_VERSION}

# Install required dependencies for Pterodactyl
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create the container user required by Pterodactyl
RUN useradd -m -d /home/container -s /bin/bash container

# Copy entrypoint and startup scripts
COPY --chown=container:container entrypoint.sh /entrypoint.sh
COPY --chown=container:container start.sh /start.sh
RUN chmod +x /entrypoint.sh /start.sh

# Switch to container user as required by Pterodactyl
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

# Pterodactyl uses this as the entrypoint
CMD ["/bin/bash", "/entrypoint.sh"]
ENTRYPOINT [ "/bin/bash", "/entrypoint.sh"]
