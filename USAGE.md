# Installation and Usage Guide

This guide provides detailed instructions for building, deploying, and using the Archipelago Pterodactyl egg.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Building the Docker Image](#building-the-docker-image)
3. [Installing the Egg in Pterodactyl](#installing-the-egg-in-pterodactyl)
4. [Creating and Configuring a Server](#creating-and-configuring-a-server)
5. [Uploading and Managing Game Files](#uploading-and-managing-game-files)
6. [Troubleshooting](#troubleshooting)

## Prerequisites

### For Building the Image
- Docker Engine (version 23.0 or later) or Podman (version 4.0 or later)
- Docker Buildx plugin (for multi-architecture builds)
- Git (for cloning the repository)

### For Pterodactyl Panel
- Pterodactyl Panel installed and configured
- Access to the admin panel
- A Docker registry to host your image (Docker Hub, GitHub Container Registry, etc.)

## Building the Docker Image

### 1. Clone the Repository

```bash
git clone https://github.com/alex73630/archipelago-pterodactyl.git
cd archipelago-pterodactyl
```

### 2. Build the Image

#### Standard Build (Latest Archipelago Version)

```bash
docker build -t ghcr.io/alex73630/archipelago-pterodactyl:latest .
```

#### Build with Specific Archipelago Version

```bash
docker build --build-arg ARCHIPELAGO_VERSION=0.4.6 \
  -t ghcr.io/alex73630/archipelago-pterodactyl:0.4.6 .
```

#### Multi-Architecture Build (for ARM and AMD64)

```bash
docker buildx build --platform linux/amd64,linux/arm64 \
  -t ghcr.io/alex73630/archipelago-pterodactyl:latest \
  --push .
```

### 3. Push to Registry

Replace `ghcr.io/alex73630` with your own registry:

```bash
docker push ghcr.io/alex73630/archipelago-pterodactyl:latest
```

For GitHub Container Registry, you need to authenticate first:

```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
docker push ghcr.io/alex73630/archipelago-pterodactyl:latest
```

## Installing the Egg in Pterodactyl

### 1. Access Admin Panel

Log in to your Pterodactyl admin panel as an administrator.

### 2. Navigate to Nests

Go to **Admin Panel** → **Nests** in the sidebar.

### 3. Create or Select a Nest

You can either:
- Use an existing nest (e.g., "Game Servers")
- Create a new nest specifically for Archipelago

### 4. Import the Egg

1. Click **Import Egg** button
2. Upload the `egg-archipelago-multiserver.json` file
3. Select the target nest
4. Click **Import**

### 5. Configure Docker Image

After importing, edit the egg if needed to ensure it points to your Docker image:
- Click on the egg name
- Go to the **Configuration** tab
- Under **Docker Images**, ensure it lists your image: `ghcr.io/alex73630/archipelago-pterodactyl:latest`

## Creating and Configuring a Server

### 1. Create New Server

1. Go to **Servers** → **Create Server**
2. Fill in basic information:
   - **Server Name**: Your preferred name
   - **Server Owner**: Select the user
   - **Nest**: Select the nest containing the Archipelago egg
   - **Egg**: Select "Archipelago MultiServer"

### 2. Resource Allocation

Configure resources:
- **Memory**: Recommended 512MB minimum, 1GB+ for larger games
- **Disk Space**: At least 1GB for game files
- **CPU Limit**: Depends on your server capacity

### 3. Port Allocation

- **Primary Port**: Will be used for the game server (default: 38281)
- Ensure the port is open in your firewall

### 4. Configure Variables

Set the server variables according to your needs:

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| Server Port | Port the server listens on | 38281 | 38281 |
| Server Host | Host address to bind to | 0.0.0.0 | 0.0.0.0 |
| Server Password | Password for players | (empty) | MyGamePass123 |
| Admin Password | Password for admin commands | (empty) | AdminPass456 |
| Disable Save | Disable server saving | false | false |
| Log Level | Logging verbosity | info | info |
| Use Embedded Options | Use game file options | false | true |
| SSL Certificate Path | SSL cert file path | (empty) | /home/container/cert.pem |
| SSL Certificate Key Path | SSL key file path | (empty) | /home/container/key.pem |

### 5. Install and Start

1. Click **Create Server**
2. Wait for installation to complete
3. Start the server

## Uploading and Managing Game Files

### 1. Access File Manager

1. Go to your server in the Pterodactyl panel
2. Click on **Files** tab

### 2. Navigate to Games Folder

You should see a `games` folder in the root directory. If not, create it.

### 3. Upload Your Game File

1. Click on the `games` folder to open it
2. Click **Upload** button
3. Select your `.zip` or `.archipelago` game file
4. Wait for upload to complete

**Supported file formats:**
- `.zip` - Archipelago multiworld zip files
- `.archipelago` - Archipelago save files

### 4. Restart the Server

After uploading your game file:
1. Stop the server (if running)
2. Start the server
3. The server will automatically detect and load the game file

### 5. Multiple Games

The server will load the **first** game file it finds. To switch games:
1. Stop the server
2. Delete or rename the current game file
3. Upload or rename the new game file
4. Start the server

## Server Console

### Viewing Server Status

Once started, the console will show:
```
===================================
Archipelago MultiServer for Pterodactyl
===================================
Checking games directory for game files...
Found game file: /home/container/games/mygame.zip
Setting port: 38281
Setting host: 0.0.0.0
===================================
Starting Archipelago Server:
python /home/container/app/MultiServer.py --port 38281 --host 0.0.0.0 /home/container/games/mygame.zip
===================================
```

### Admin Commands

If you set an admin password, you can use admin commands in the console:
- `/help` - Show available commands
- `/players` - List connected players
- `/kick <player>` - Kick a player
- `/save` - Force save the game state

## Troubleshooting

### Server Won't Start

**Problem**: Server immediately stops after starting

**Solutions**:
1. Check console logs for error messages
2. Ensure a game file is uploaded to the `games` folder
3. Verify the game file is a valid Archipelago file
4. Check that the port is not already in use

### Game File Not Detected

**Problem**: Server starts but doesn't load the game file

**Solutions**:
1. Verify the file is in the `games` folder (not a subfolder)
2. Ensure the file has a `.zip` or `.archipelago` extension
3. Check file permissions in the console
4. Try renaming the file to remove special characters

### Players Can't Connect

**Problem**: Server is running but players cannot connect

**Solutions**:
1. Verify the port is open in your firewall
2. Check that SERVER_HOST is set to `0.0.0.0`
3. Ensure players are using the correct IP address and port
4. Verify any server password is correct
5. Check network configuration in Pterodactyl wings

### Memory Issues

**Problem**: Server crashes with memory errors

**Solutions**:
1. Increase allocated memory in server settings
2. Check for memory leaks in console logs
3. Restart the server periodically for long-running games

### SSL/HTTPS Issues

**Problem**: SSL certificate errors

**Solutions**:
1. Ensure certificate files are uploaded to `/home/container/`
2. Verify certificate file paths in variables
3. Check certificate validity and format
4. Ensure private key matches the certificate

## Advanced Configuration

### Using Docker Compose for Testing

Before deploying to Pterodactyl, you can test locally:

```bash
# Create games directory
mkdir -p games

# Copy your game file
cp /path/to/your/game.zip games/

# Start with docker-compose
docker-compose up -d

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

### Custom Archipelago Versions

To use a specific Archipelago version:

1. Build with specific version:
   ```bash
   docker build --build-arg ARCHIPELAGO_VERSION=0.4.6 \
     -t your-registry/archipelago-pterodactyl:0.4.6 .
   ```

2. Update egg configuration to use your tagged image

3. Players must use compatible client versions

### Environment Variables Reference

The following environment variables are passed by Pterodactyl:

| Variable | Used By | Purpose |
|----------|---------|---------|
| STARTUP | entrypoint.sh | Command to execute |
| SERVER_PORT | start.sh | Server port number |
| HOST | start.sh | Bind address |
| SERVER_PASSWORD | start.sh | Player password |
| PASSWORD | start.sh | Admin password |
| DISABLE_SAVE | start.sh | Disable saves |
| LOGLEVEL | start.sh | Log verbosity |
| USE_EMBEDDED_OPTIONS | start.sh | Use file options |
| CERT | start.sh | SSL certificate |
| CERT_KEY | start.sh | SSL key |

## Support and Resources

- **Archipelago Documentation**: https://archipelago.gg/
- **Archipelago GitHub**: https://github.com/ArchipelagoMW/Archipelago
- **Pterodactyl Documentation**: https://pterodactyl.io/
- **This Repository**: https://github.com/alex73630/archipelago-pterodactyl

## Contributing

If you find issues or have improvements:
1. Open an issue on GitHub
2. Submit a pull request
3. Join discussions in the repository

## License

This project follows the same license as Archipelago.
