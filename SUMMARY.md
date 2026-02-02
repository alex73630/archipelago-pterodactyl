# Project Summary

This repository provides a complete solution for hosting Archipelago MultiWorld randomizer games on Pterodactyl Panel.

## What Was Created

### Core Files

1. **Dockerfile**
   - Based on official Archipelago image (`ghcr.io/archipelagomw/archipelago`)
   - Follows Pterodactyl requirements:
     - Creates `container` user with home at `/home/container`
     - Sets USER, ENV, and WORKDIR correctly
     - Includes bash and unzip utilities
   - Copies Archipelago files to container home
   - Sets up games directory for file uploads
   - Multi-architecture support (amd64, arm64)

2. **entrypoint.sh**
   - Pterodactyl-compliant entrypoint script
   - Processes STARTUP variable with variable substitution
   - Outputs Python version for debugging
   - Executes the server startup command

3. **start.sh**
   - Game server startup script
   - Automatically detects .zip and .archipelago files in games folder
   - Configures MultiServer with all environment variables
   - Supports all Archipelago MultiServer options

4. **egg-archipelago-multiserver.json**
   - Complete Pterodactyl egg configuration
   - Defines all server variables with validation rules
   - Includes installation script
   - Configures startup detection
   - Author: alex73630+pterodactyl@gmail.com

### Documentation

5. **README.md**
   - Project overview
   - Quick start guide with two options (pre-built vs self-build)
   - Configuration details
   - Technical information
   - CI/CD and release information
   - Support and credits

6. **USAGE.md**
   - Comprehensive installation guide
   - Step-by-step Pterodactyl setup
   - Server configuration instructions
   - Game file management guide
   - Troubleshooting section
   - Advanced configuration examples
   - Environment variable reference

### Supporting Files

7. **.gitignore**
   - Excludes build artifacts
   - Excludes temporary files
   - Excludes IDE files
   - Excludes game files (should be in deployment)

8. **.dockerignore**
   - Optimizes Docker build context
   - Excludes documentation
   - Excludes development files
   - Keeps image size minimal

9. **docker-compose.yml**
   - Local testing setup
   - Proper environment variable mapping
   - Volume mounting for games folder
   - Network and port configuration

### CI/CD Workflows

10. **.github/workflows/build-and-publish.yml**
    - Triggers on version tags (v*.*.*)
    - Builds multi-architecture images
    - Pushes to GitHub Container Registry
    - Creates GitHub Releases with assets
    - Generates release notes automatically
    - Tags images with semver patterns

11. **.github/workflows/docker-build-test.yml**
    - Runs on PRs and main branch pushes
    - Validates Dockerfile with hadolint
    - Validates shell script syntax
    - Validates JSON files
    - Builds Docker image for testing
    - PR builds: amd64 only (faster)
    - Main builds: multi-arch + push to registry

12. **.github/workflows/README.md**
    - Workflow documentation
    - Usage instructions
    - Release process guide
    - Troubleshooting tips
    - Multi-architecture details

## Key Features

### Pterodactyl Compliance
- ✅ Container user and home directory requirements met
- ✅ Proper entrypoint implementation
- ✅ Variable substitution support
- ✅ Startup detection configured
- ✅ Installation script included

### User Experience
- 🎮 Simple game hosting (drop zip file and restart)
- ⚙️ All MultiServer options configurable via panel
- 🔒 Password protection support
- 📊 Console logging and monitoring
- 🌐 Optional SSL/HTTPS support

### Development & Operations
- 🚀 Automated builds and releases
- 🏗️ Multi-architecture support
- 🧪 Automated testing on PRs
- 📦 Pre-built images on GHCR
- 📚 Comprehensive documentation

## Configuration Variables

The egg provides these configurable variables:

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| SERVER_PORT | integer | 38281 | Server port |
| HOST | string | 0.0.0.0 | Bind address |
| SERVER_PASSWORD | string | (empty) | Player password |
| PASSWORD | string | (empty) | Admin password |
| DISABLE_SAVE | boolean | false | Disable saves |
| LOGLEVEL | string | info | Log level |
| USE_EMBEDDED_OPTIONS | boolean | false | Use file options |
| CERT | string | (empty) | SSL certificate path |
| CERT_KEY | string | (empty) | SSL key path |

## Deployment Flow

### For End Users (Pterodactyl Server Owners)

1. Download egg from releases
2. Import into Pterodactyl panel
3. Create new server with egg
4. Upload game file to games folder
5. Start server and play!

### For Developers/Maintainers

1. Make changes to code
2. Create PR (triggers test workflow)
3. Merge to main (builds and pushes main branch image)
4. Create version tag (triggers release workflow)
5. Release created with artifacts
6. Docker images available in GHCR

## Technical Specifications

### Docker Image
- **Registry**: GitHub Container Registry (ghcr.io)
- **Base Image**: ghcr.io/archipelagomw/archipelago:latest
- **Architectures**: linux/amd64, linux/arm64
- **Size**: ~1.5GB (inherited from base image)

### Supported Game Files
- `.zip` - Archipelago multiworld archives
- `.archipelago` - Archipelago save files

### Network Requirements
- Default port: 38281 (configurable)
- Protocol: TCP
- Optional: SSL/TLS support

### System Requirements
- Minimum RAM: 512MB (1GB+ recommended)
- Disk Space: 1GB minimum for game files
- CPU: Minimal (depends on game size and player count)

## Security

- ✅ No security vulnerabilities found (CodeQL scan)
- ✅ Runs as non-root user (container)
- ✅ No hardcoded secrets
- ✅ Optional password protection
- ✅ Optional SSL/TLS encryption

## Testing

All components validated:
- ✅ Dockerfile syntax and Pterodactyl compliance
- ✅ Shell script syntax (bash -n)
- ✅ JSON schema validation
- ✅ YAML syntax (docker-compose)
- ✅ GitHub Actions workflow syntax

## Future Enhancements

Potential improvements:
- Multiple game file support with selection
- Auto-restart on game completion
- Metrics and monitoring integration
- Backup/restore functionality
- Web interface integration
- Discord bot integration

## Support Channels

- **Issues**: GitHub Issues in this repository
- **Archipelago**: https://archipelago.gg/
- **Pterodactyl**: https://pterodactyl.io/

## Success Criteria

All requirements from the problem statement met:

✅ Modified Dockerfile from Archipelago adapted to Pterodactyl
✅ Uses technique from ArchipelagoServerDocker (multi-stage copy)
✅ Egg config JSON with all necessary settings
✅ Scripts and configs to run the container
✅ Capability to host games by dropping zip files in games folder
✅ Easy runtime management through Pterodactyl Panel
✅ Automated build and release system

## Repository Structure

```
archipelago-pterodactyl/
├── .github/
│   └── workflows/
│       ├── build-and-publish.yml      # Release workflow
│       ├── docker-build-test.yml      # Testing workflow
│       └── README.md                  # Workflow documentation
├── .dockerignore                      # Docker build optimization
├── .gitignore                         # Git ignore rules
├── Dockerfile                         # Pterodactyl-compliant image
├── README.md                          # Main documentation
├── USAGE.md                           # Detailed usage guide
├── docker-compose.yml                 # Local testing
├── egg-archipelago-multiserver.json   # Pterodactyl egg
├── entrypoint.sh                      # Pterodactyl entrypoint
└── start.sh                           # Server startup script
```

## License

This project follows the same license as Archipelago.

---

**Created**: February 2, 2026
**Status**: ✅ Complete and Ready for Use
