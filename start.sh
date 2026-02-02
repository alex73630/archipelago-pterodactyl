#!/bin/bash

# Exit on error
set -e

echo "==================================="
echo "Archipelago MultiServer for Pterodactyl"
echo "==================================="

# Initialize arguments array
ARGS=("python" "/home/container/app/MultiServer.py")

# Check for game files in games directory
GAME_FILE=""
if [ -d "/home/container/games" ]; then
    echo "Checking games directory for game files..."
    
    # Look for .zip or .archipelago files
    for ext in zip archipelago; do
        for file in /home/container/games/*."$ext"; do
            if [ -f "$file" ]; then
                GAME_FILE="$file"
                echo "Found game file: $GAME_FILE"
                break 2
            fi
        done
    done
fi

# PORT: maps to --port <value>
if [ -n "${SERVER_PORT:-}" ]; then
    echo "Setting port: $SERVER_PORT"
    ARGS+=("--port" "$SERVER_PORT")
fi

# HOST: maps to --host <value>
if [ -n "${HOST:-}" ]; then
    echo "Setting host: $HOST"
    ARGS+=("--host" "$HOST")
fi

# SERVER_PASSWORD: maps to --server_password <value>
if [ -n "${SERVER_PASSWORD:-}" ]; then
    echo "Setting server password"
    ARGS+=("--server_password" "$SERVER_PASSWORD")
fi

# PASSWORD: maps to --password <value>
if [ -n "${PASSWORD:-}" ]; then
    echo "Setting password"
    ARGS+=("--password" "$PASSWORD")
fi

# DISABLE_SAVE: maps to --disable_save
if [ "${DISABLE_SAVE:-false}" = "true" ] || [ "${DISABLE_SAVE:-false}" = "True" ]; then
    echo "Disabling save"
    ARGS+=("--disable_save")
fi

# CERT: maps to --cert <value>
if [ -n "${CERT:-}" ]; then
    echo "Setting certificate: $CERT"
    ARGS+=("--cert" "$CERT")
fi

# CERT_KEY: maps to --cert_key <value>
if [ -n "${CERT_KEY:-}" ]; then
    echo "Setting certificate key: $CERT_KEY"
    ARGS+=("--cert_key" "$CERT_KEY")
fi

# LOGLEVEL: maps to --loglevel <value>
if [ -n "${LOGLEVEL:-}" ]; then
    echo "Setting log level: $LOGLEVEL"
    ARGS+=("--loglevel" "$LOGLEVEL")
fi

# USE_EMBEDDED_OPTIONS: maps to --use_embedded_options
if [ "${USE_EMBEDDED_OPTIONS:-false}" = "true" ] || [ "${USE_EMBEDDED_OPTIONS:-false}" = "True" ]; then
    echo "Using embedded options"
    ARGS+=("--use_embedded_options")
fi

# Add game file as positional argument if found
if [ -n "$GAME_FILE" ]; then
    ARGS+=("$GAME_FILE")
else
    echo "WARNING: No game file found in games directory"
    echo "Place a .zip or .archipelago file in the games directory to host a game"
fi

# Display the final command
echo "==================================="
echo "Starting Archipelago Server:"
echo "${ARGS[*]}"
echo "==================================="

# Execute the command
exec "${ARGS[@]}"
