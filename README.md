# Archipelago Pterodactyl Egg

This repository contains a custom Pterodactyl egg for hosting Archipelago MultiWorld randomizer games. It provides an easy way to deploy Archipelago game servers through the Pterodactyl panel.

## Features

- 🎮 Easy game hosting by simply dropping .zip or .archipelago files in the games folder
- 🐳 Based on the official Archipelago Docker image
- ⚙️ Configurable server settings through Pterodactyl panel
- 🔒 Optional password protection and SSL support
- 📦 Automatic game file detection and loading

## Quick Start

### 1. Build the Docker Image

Build the Docker image from this repository:

```bash
docker build -t ghcr.io/alex73630/archipelago-pterodactyl:latest .
```

Or specify a specific Archipelago version:

```bash
docker build --build-arg ARCHIPELAGO_VERSION=0.4.6 -t ghcr.io/alex73630/archipelago-pterodactyl:latest .
```

Push to your registry:

```bash
docker push ghcr.io/alex73630/archipelago-pterodactyl:latest
```

### 2. Import the Egg into Pterodactyl

1. Download the `egg-archipelago-multiserver.json` file
2. In your Pterodactyl admin panel, go to **Nests** → **Import Egg**
3. Upload the JSON file
4. The egg will be available for creating new servers

### 3. Create a Server

1. Create a new server in Pterodactyl
2. Select the **Archipelago MultiServer** egg
3. Configure the server settings (port, passwords, etc.)
4. Start the server

### 4. Upload Your Game

1. Navigate to the server's **File Manager** in Pterodactyl
2. Go to the `games` folder
3. Upload your `.zip` or `.archipelago` game file
4. Restart the server

The server will automatically detect and load the first game file it finds in the games folder.

## Configuration

The egg provides the following configurable variables:

### Required Settings

- **Server Port** (default: 38281): The port the server listens on
- **Server Host** (default: 0.0.0.0): The host address to bind to

### Optional Settings

- **Server Password**: Password for players to connect
- **Admin Password**: Password for admin commands
- **Disable Save** (default: false): Disable server save functionality
- **Log Level** (default: info): Logging verbosity (debug, info, warning, error)
- **Use Embedded Options** (default: false): Use options embedded in the game file

### SSL/HTTPS Settings

- **SSL Certificate Path**: Path to SSL certificate file
- **SSL Certificate Key Path**: Path to SSL certificate key file

## Files

- `Dockerfile`: Docker image configuration based on the official Archipelago image
- `start.sh`: Startup script that handles game file detection and server configuration
- `egg-archipelago-multiserver.json`: Pterodactyl egg configuration

## Technical Details

### Dockerfile

The Dockerfile uses the official Archipelago image as a base and adds:
- `unzip` utility for handling compressed game files
- `/games` directory for Pterodactyl file uploads
- Custom startup script

### Startup Script

The `start.sh` script:
1. Scans the `/games` directory for `.zip` or `.archipelago` files
2. Configures the MultiServer with environment variables from Pterodactyl
3. Launches the Archipelago MultiServer with the detected game file

## Support

For issues related to:
- **This egg/Docker setup**: Open an issue in this repository
- **Archipelago itself**: See [Archipelago GitHub](https://github.com/ArchipelagoMW/Archipelago)
- **Pterodactyl**: See [Pterodactyl documentation](https://pterodactyl.io/project/introduction.html)

## Credits

- [Archipelago MultiWorld](https://github.com/ArchipelagoMW/Archipelago) - The multiworld randomizer platform
- [ArchipelagoServerDocker](https://github.com/nmills3/ArchipelagoServerDocker) - Inspiration for the Docker setup
- [Pterodactyl Panel](https://pterodactyl.io/) - Game server management panel

## License

This project follows the same license as Archipelago. See the [Archipelago repository](https://github.com/ArchipelagoMW/Archipelago) for license details.