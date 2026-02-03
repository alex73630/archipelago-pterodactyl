#!/bin/bash

# Pterodactyl Entrypoint Script
# This script is called by Pterodactyl Wings to start the container

# Update/Install Archipelago files
echo "Updating Archipelago files..."
mkdir -p /home/container/app
cp -R /app/. /home/container/app/

# Ensure games directory exists
mkdir -p /home/container/games

# Install start script
cp /start.sh /home/container/start.sh
chmod +x /home/container/start.sh

cd /home/container || exit 1

# Output Python Version
python --version

# Replace Startup Variables
MODIFIED_STARTUP=$(eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}
