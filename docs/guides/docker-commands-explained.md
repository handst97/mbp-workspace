# Docker Commands For updating Open WebUI Explained

## Checking Container Status

### `docker ps -a | grep open-webui`
- **`docker ps`**: Lists running containers
- **`-a`**: Shows ALL containers (running and stopped)
- **`|`**: Pipe operator - sends output to next command
- **`grep open-webui`**: Filters results to only show lines containing "open-webui"

**Purpose**: Find your Open WebUI container whether it's running or stopped

---

## Inspecting Container Configuration

### `docker inspect open-webui --format='{{range .Mounts}}{{.Type}} {{.Source}} -> {{.Destination}}{{println}}{{end}}'`
- **`docker inspect`**: Shows detailed information about a Docker object
- **`open-webui`**: The container name to inspect
- **`--format`**: Uses Go template to format output
- **`{{range .Mounts}}`**: Loops through all mounted volumes
- **`{{.Type}}`**: Shows mount type (volume, bind, etc.)
- **`{{.Source}}`**: Where the volume is on the host
- **`{{.Destination}}`**: Where it's mounted in the container

**Purpose**: See what volumes are attached to preserve your data during updates

### `docker inspect open-webui --format='{{.NetworkSettings.Ports}}'`
- Shows which ports are mapped between container and host
- Example output: `8080/tcp:[{0.0.0.0 3002}]` means container port 8080 → host port 3002

**Purpose**: Know which port to use when recreating the container

### `docker inspect open-webui --format='{{.Config.Env}}'`
- Lists all environment variables set in the container
- Important for recreating container with same configuration

**Purpose**: Capture any custom environment settings

---

## Container Management

### `docker stop open-webui`
- Gracefully stops the running container
- Sends SIGTERM signal, waits for cleanup, then SIGKILL if needed
- Container still exists but is not running

**Purpose**: Safely shut down the container before removal

### `docker rm open-webui`
- Removes the stopped container completely
- Only removes container, NOT the data in volumes
- Container must be stopped first

**Purpose**: Clear out old container to make room for new one

---

## Image Management

### `docker pull ghcr.io/open-webui/open-webui:main`
- **`docker pull`**: Downloads image from registry
- **`ghcr.io`**: GitHub Container Registry (where image is hosted)
- **`open-webui/open-webui`**: Repository/image name
- **`:main`**: Tag (version) - "main" gets latest development version

**Purpose**: Download the newest version of Open WebUI

### `docker images | grep open-webui`
- **`docker images`**: Lists all downloaded images
- Shows repository, tag, image ID, creation date, and size

**Purpose**: See what versions of Open WebUI you have

### `docker rmi <image-id>`
- **`docker rmi`**: Remove image
- **`<image-id>`**: The specific image to delete
- Can also use `repository:tag` format

**Purpose**: Clean up old images to save disk space

---

## Running Containers

### `docker run -d --name open-webui -p 3002:8080 -v open-webui-fresh:/app/backend/data --restart always ghcr.io/open-webui/open-webui:main`

Breaking this down:
- **`docker run`**: Creates and starts a new container
- **`-d`**: Detached mode (runs in background)
- **`--name open-webui`**: Names the container "open-webui"
- **`-p 3002:8080`**: Port mapping - host:container
  - Access on your Mac at port 3002
  - Container listens on port 8080 internally
- **`-v open-webui-fresh:/app/backend/data`**: Volume mount
  - `open-webui-fresh`: Named volume on your Mac
  - `/app/backend/data`: Where it's mounted inside container
  - Preserves your data between updates
- **`--restart always`**: Container restarts if it crashes or Docker restarts
- **`ghcr.io/open-webui/open-webui:main`**: The image to use

**Purpose**: Start new container with updated image while keeping your data

---

## Monitoring

### `docker logs open-webui --tail 20`
- **`docker logs`**: Shows container output/logs
- **`open-webui`**: Container name
- **`--tail 20`**: Only show last 20 lines

**Purpose**: Check if container started successfully

### `docker ps | grep open-webui`
- Shows only running containers with "open-webui" in the output
- Includes status like "Up 2 hours (healthy)"

**Purpose**: Verify container is running and healthy

---

## Storage Analysis

### `docker system df`
Shows disk usage for:
- **Images**: All downloaded images
- **Containers**: Space used by containers
- **Volumes**: Persistent data storage
- **Build Cache**: Cached layers from building images
- **RECLAIMABLE**: Space you can free up

**Purpose**: Understand where Docker storage is being used

### `du -h ~/Library/Containers/com.docker.docker/Data/vms/0/data/Docker.raw`
- **`du`**: Disk usage command
- **`-h`**: Human-readable format (GB, MB)
- Shows actual size of Docker's virtual disk file

**Purpose**: See total space Docker is using on your Mac

---

## Cleanup Commands

### `docker image prune -a`
- **`prune`**: Removes unused resources
- **`-a`**: All unused images, not just dangling ones
- Will ask for confirmation

**Purpose**: Free up space from unused images

### `docker system prune -a --volumes`
- Removes ALL unused:
  - Containers
  - Networks
  - Images
  - Optionally volumes (with `--volumes`)
- **BE CAREFUL**: This is aggressive cleanup

**Purpose**: Major cleanup when disk space is critical

---

## One-Liner Update Command

### `docker stop open-webui && docker rm open-webui && docker run -d --name open-webui -p 3002:8080 -v open-webui-fresh:/app/backend/data --restart always ghcr.io/open-webui/open-webui:main`

- **`&&`**: Runs next command only if previous succeeded
- Combines stop, remove, and run into one command
- Ensures each step completes before moving on

**Purpose**: Quick update after pulling latest image

---

## Pro Tips

1. **Always check volumes before removing containers** - Your data lives there!
2. **Use `--help`** with any command for more options: `docker run --help`
3. **Container names must be unique** - That's why we remove old one first
4. **Ports must be available** - Check with `lsof -i :3002` on Mac
5. **Images are layered** - Pulling updates often just downloads changed layers

## Common Issues

### "Port already in use"
```bash
# Find what's using the port
lsof -i :3002
# Kill the process if needed
kill -9 <PID>
```

### "Container name already in use"
```bash
# Remove the old container
docker rm open-webui
# Or rename it
docker rename open-webui open-webui-old
```

### "No space left on device"
```bash
# Clean up unused Docker resources
docker system prune -a
# Check Docker.raw size
ls -lh ~/Library/Containers/com.docker.docker/Data/vms/0/data/Docker.raw
```