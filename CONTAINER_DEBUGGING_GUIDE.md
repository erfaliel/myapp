# Container Executable Debugging Guide

## Problem: `/bin/sh: can't open './bin/hello': No such file or directory`

This guide documents the step-by-step process for investigating why a Docker container can't find an executable that should exist in the image.

## Step 1: Verify the Container is Running

First, check if your containers are running:

```bash
docker compose ps
```

If the web container keeps exiting, you'll need to start it in a way that keeps it alive for debugging:

```bash
# Start with an override command to keep container running
docker compose run --rm web sleep infinity
```

Or in a separate terminal, find the container ID:
```bash
docker ps -a
```

## Step 2: Inspect the Built Image

Before investigating the running container, verify the executable exists in the built image:

```bash
# List the contents of the bin directory in the image
docker run --rm hello-web ls -la bin/

# Expected output should show:
# -rwxr-xr-x 1 root root XXXX DATE hello
```

If `bin/hello` doesn't exist in the image, the problem is in your Dockerfile build process.

## Step 3: Enter the Running Container

Get shell access to the running container:

```bash
# Get the container ID
CONTAINER_ID=$(docker compose ps -q web)

# Enter the container with an interactive shell
docker exec -it $CONTAINER_ID /bin/sh
```

## Step 4: Investigate the File System Inside Container

Once inside the container, investigate the current state:

```bash
# Check current working directory
pwd
# Should show: /app

# List contents of current directory
ls -la

# Check if bin directory exists
ls -la bin/
```

### Key Discovery Point

If you see that the `bin/` directory is missing or empty, but you know it exists in the image, this indicates a **volume mount issue**.

## Step 5: Compare Image vs Running Container

Exit the container and compare the image contents with the running container:

```bash
# Exit container shell
exit

# Check image contents
docker run --rm hello-web ls -la bin/

# Check running container contents  
docker exec -it $CONTAINER_ID ls -la bin/
```

If the image shows `bin/hello` but the running container doesn't, you have a volume mount problem.

## Step 6: Inspect Volume Mounts

Check what volumes are mounted on the container:

```bash
# Inspect the container's mount points
docker inspect $CONTAINER_ID | grep -A 10 -B 5 "Mounts"
```

Look for output like:
```json
"Mounts": [
    {
        "Type": "bind",
        "Source": "/Users/vincent/tmp_forTheDev/elixir/hello",
        "Destination": "/app",
        ...
    }
]
```

## Step 7: Check docker-compose.yml Configuration

Examine your `docker-compose.yml` for problematic volume mounts:

```bash
# Look for volume definitions in docker-compose.yml
grep -A 5 -B 5 "volumes:" docker-compose.yml
```

### The Problem Pattern

If you see something like:
```yaml
services:
  web:
    volumes:
      - .:/app  # ← This is the problem!
```

This bind mount overlays the entire `/app` directory in the container with your host project directory, effectively hiding everything that was built into the image at `/app`.

## Step 8: Verify the Problem

To confirm this is the issue, temporarily start a container without the volume mount:

```bash
# Run container without volumes to test
docker run --rm -it hello-web /bin/sh

# Inside this container, check:
ls -la bin/hello
# This should show the executable exists

# Try running it:
./bin/hello start
# This might fail due to missing environment variables, but the file should be found
```

## Step 9: Understanding the Root Cause

The issue occurs because:

1. **During build**: The Elixir release process creates `bin/hello` inside the Docker image at `/app/bin/hello`
2. **During runtime**: The volume mount `.:/app` replaces the entire `/app` directory with your host source code
3. **Result**: The compiled release binary is hidden by the host directory mount, which only contains source code

## Step 10: The Solution

Remove or modify the problematic volume mount:

```yaml
# BEFORE (problematic):
services:
  web:
    volumes:
      - .:/app

# AFTER (fixed):
services:
  web:
    # Remove the volume mount entirely, or mount only specific subdirectories if needed
    # volumes:
    #   - ./config:/app/config  # Mount only specific dirs if you need live reload
```

## Step 11: Verify the Fix

After removing the volume mount:

```bash
# Rebuild and restart
docker compose down
docker compose up --build

# The container should now start successfully
```

## Additional Debugging Commands

### Check file permissions and type:
```bash
docker exec -it $CONTAINER_ID file bin/hello
docker exec -it $CONTAINER_ID stat bin/hello
```

### Check if shell can execute the file:
```bash
docker exec -it $CONTAINER_ID /bin/sh -c "test -x bin/hello && echo 'Executable' || echo 'Not executable'"
```

### Verify environment variables:
```bash
docker exec -it $CONTAINER_ID env | grep DATABASE_URL
```

## Summary

The key insight is that volume mounts can hide files that exist in the Docker image. When debugging "file not found" errors:

1. Always compare image contents vs running container contents
2. Check for volume mounts that might be overlaying important directories
3. Use `docker inspect` to see exactly what's mounted where
4. Test without volumes to isolate the problem

This type of issue is common in development setups where you want to mount source code for live reloading, but accidentally hide build artifacts in the process.
