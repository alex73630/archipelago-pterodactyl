#!/bin/bash

# Pterodactyl Entrypoint Script
# This script is called by Pterodactyl Wings to start the container

cd /home/container || exit 1

# Output Python Version
python --version

# Replace Startup Variables
MODIFIED_STARTUP=$(eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}
