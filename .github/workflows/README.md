# GitHub Actions Workflows

This directory contains GitHub Actions workflows for building, testing, and publishing the Archipelago Pterodactyl Docker image.

## Workflows

### 1. Build and Publish (`build-and-publish.yml`)

**Triggers:**
- When a version tag is pushed (e.g., `v1.0.0`, `v0.4.6`)
- Can be manually triggered via workflow_dispatch

**What it does:**
- Builds multi-architecture Docker images (amd64 and arm64)
- Pushes images to GitHub Container Registry (ghcr.io)
- Creates GitHub Release with egg file and documentation
- Tags images with:
  - Semver tags (e.g., `1.0.0`, `1.0`, `1`)
  - `latest` tag for default branch

**Usage:**

To create a release:

```bash
# Create and push a version tag
git tag v1.0.0
git push origin v1.0.0

# The workflow will automatically:
# 1. Build the Docker image
# 2. Push to ghcr.io/alex73630/archipelago-pterodactyl:v1.0.0
# 3. Create a GitHub release with the egg file attached
```

**Manual trigger:**

You can also manually trigger this workflow from the Actions tab in GitHub.

### 2. Docker Build Test (`docker-build-test.yml`)

**Triggers:**
- Pull requests to main branch (when Dockerfile or scripts change)
- Pushes to main branch (when Dockerfile or scripts change)

**What it does:**
- Validates Dockerfile syntax with hadolint
- Validates shell script syntax
- Validates JSON files
- Builds Docker image to ensure it compiles
- For PRs: Only builds for amd64 (faster testing)
- For main branch pushes: Builds and pushes multi-arch images with branch tags

**CI/CD Integration:**

This workflow ensures code quality before merging:
- Shell scripts are syntactically valid
- Dockerfile follows best practices
- JSON configuration is valid
- Docker image builds successfully

## Required Secrets

These workflows use built-in GitHub secrets and tokens:

- `GITHUB_TOKEN` - Automatically provided by GitHub Actions
  - Used for pushing to GitHub Container Registry
  - Used for creating GitHub Releases

No additional secrets configuration is needed!

## Permissions

The workflows require the following permissions:

```yaml
permissions:
  contents: write    # For creating releases
  packages: write    # For pushing to GHCR
  id-token: write    # For OIDC token generation
```

These are configured in each workflow file.

## Docker Image Registry

Images are published to GitHub Container Registry at:
```
ghcr.io/alex73630/archipelago-pterodactyl
```

### Available Tags

After releases, images are available with multiple tags:

- `latest` - Latest stable release
- `v1.0.0` - Specific version
- `1.0.0` - Version without 'v' prefix
- `1.0` - Major.minor version
- `1` - Major version only
- `main-<sha>` - Main branch builds with commit SHA

## Multi-Architecture Support

Images are built for multiple architectures:
- `linux/amd64` - Standard x86_64 systems
- `linux/arm64` - ARM64 systems (e.g., Apple Silicon, ARM servers)

Docker will automatically pull the correct architecture for your system.

## Creating a Release

### Standard Release Process

1. **Update version in documentation** (if needed)

2. **Commit all changes**
   ```bash
   git add .
   git commit -m "Prepare release v1.0.0"
   git push origin main
   ```

3. **Create and push tag**
   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```

4. **Wait for workflow to complete**
   - Check the Actions tab in GitHub
   - Wait for the "Build and Publish" workflow to finish

5. **Verify release**
   - Go to the Releases page
   - Download and test the egg file
   - Verify Docker image: `docker pull ghcr.io/alex73630/archipelago-pterodactyl:v1.0.0`

### Pre-release

To create a pre-release (beta, rc, etc.):

```bash
git tag -a v1.0.0-beta.1 -m "Beta release 1.0.0-beta.1"
git push origin v1.0.0-beta.1
```

The workflow will automatically mark it as a pre-release.

## Troubleshooting

### Workflow fails on Docker build

**Check:**
- Dockerfile syntax errors
- Base image availability
- Build arguments are correct

**Fix:**
- Test locally first: `docker build -t test .`
- Check workflow logs in Actions tab

### Release not created

**Check:**
- Tag format is correct (must start with 'v')
- Workflow has necessary permissions
- No existing release with same tag

### Docker image not accessible

**Check:**
- Package visibility in GitHub settings
- Image was successfully pushed (check workflow logs)
- Using correct image name and tag

**Make image public:**
1. Go to your repository
2. Click on "Packages" on the right side
3. Click on the package name
4. Go to "Package settings"
5. Change visibility to "Public"

## Testing Locally

Before creating a release, test the build locally:

```bash
# Test build
docker build -t archipelago-pterodactyl:test .

# Test with docker-compose
docker-compose up

# Test scripts
bash -n entrypoint.sh start.sh
python3 -m json.tool egg-archipelago-multiserver.json
```

## Monitoring Builds

- View workflow runs: `https://github.com/alex73630/archipelago-pterodactyl/actions`
- View releases: `https://github.com/alex73630/archipelago-pterodactyl/releases`
- View packages: `https://github.com/alex73630/archipelago-pterodactyl/pkgs/container/archipelago-pterodactyl`

## Contributing

When contributing changes to Docker-related files:

1. Create a feature branch
2. Make your changes
3. Create a pull request to main
4. The "Docker Build Test" workflow will automatically run
5. Ensure all checks pass before merging

After merging to main, create a tag to trigger a release.
