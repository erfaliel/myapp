# Docker Compose Troubleshooting Report
## Elixir/Phoenix Application Setup

**Project:** Hello (Elixir/Phoenix)  
**Date:** June 29, 2025  
**Location:** `/Users/vincent/tmp_forTheDev/elixir/hello`  
**Environment:** MacOS with Docker Compose

---

## Summary

This report documents the comprehensive troubleshooting process for setting up an Elixir/Phoenix application with PostgreSQL using Docker Compose. Multiple critical issues were identified and resolved to achieve a fully functional development environment.

---

## Initial System State

### Homebrew Maintenance
- **Action:** Upgraded all outdated Homebrew packages and casks
- **Packages Updated:** 9 formulae including erlang, python@3.13, kubernetes-cli, and powershell cask
- **Issue:** `brew link --overwrite docker-compose` failed due to permissions on `/usr/local/lib/docker`
- **Resolution:** Uninstalled docker-compose to avoid permission conflicts

---

## Major Issues Identified and Resolved

### 1. Missing Environment Variables

#### Problem
- Application failing with missing `DATABASE_URL` error
- No `.env` file present in project

#### Solution
- **Created `.env` file** with PostgreSQL connection string:
  ```
  DATABASE_URL=postgres://postgres:postgres@db:5432/hello_dev
  SECRET_KEY_BASE=[generated-secret-key]
  ```

#### Commands Used
```bash
mix phx.gen.secret  # Generated SECRET_KEY_BASE
```

---

### 2. Container Executable Issues

#### Problem
- Web container failing with: `/bin/sh: can't open './bin/hello': No such file or directory`
- Executable `bin/hello` existed in built image but was inaccessible at runtime

#### Root Cause Analysis
1. **Initial Dockerfile CMD Issues:**
   - Tried: `CMD ["/bin/sh", "./bin/hello", "start"]` (incorrect syntax)
   - Shell script existed with correct permissions

2. **Critical Discovery - Bind Mount Problem:**
   - `docker-compose.yml` had volume mount: `.:/app`
   - This overlay hid the release executable built during image creation
   - Host directory didn't contain generated release files

#### Solution
1. **Removed problematic bind mount** from `docker-compose.yml`
2. **Corrected Dockerfile CMD** to: `CMD ["./bin/hello", "start"]`
3. **Rebuilt images** after volume cleanup

#### Commands Used
```bash
docker compose down --volumes --remove-orphans
docker system prune -f
docker compose up --build
```

---

### 3. PostgreSQL Database Issues

#### Problem 1: Database Corruption
- PostgreSQL failing with: `FATAL: could not open file 'global/pg_filenode.map': No such file or directory`
- Repeated startup failures and recovery attempts

#### Problem 2: Missing Database
- Application couldn't connect because `hello_dev` database didn't exist

#### Solution
1. **Database Cleanup:**
   ```bash
   docker compose down --volumes  # Removed corrupted volumes
   ```

2. **Manual Database Creation (Initial):**
   ```bash
   docker compose up -d db  # Start only database
   docker exec -it hello-db-1 createdb -U postgres hello_dev
   ```

3. **Automated Database Creation:**
   - **Updated `docker-compose.yml`** to include:
     ```yaml
     db:
       environment:
         POSTGRES_DB: hello_dev  # Auto-creates database on init
         POSTGRES_USER: postgres
         POSTGRES_PASSWORD: postgres
     ```

---

### 4. Docker Compose Configuration

#### Problem
- Obsolete `version` attribute warning in `docker-compose.yml`

#### Solution
- **Removed deprecated version specification**
- **Added automatic database creation** via `POSTGRES_DB` environment variable

---

## Final Working Configuration

### `.env` File
```
DATABASE_URL=postgres://postgres:postgres@db:5432/hello_dev
SECRET_KEY_BASE=[generated-64-character-secret]
```

### Updated `docker-compose.yml` (Key Changes)
```yaml
services:
  web:
    # ... other config
    # REMOVED: volumes: .:/app (this was hiding the executable)
    
  db:
    environment:
      POSTGRES_DB: hello_dev      # NEW: Auto-creates database
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
```

### Corrected Dockerfile CMD
```dockerfile
CMD ["./bin/hello", "start"]
```

---

## Lessons Learned

### Critical Issues to Avoid
1. **Bind Mount Overlays:** Volume mounts can hide files built during image creation
2. **Missing Environment Variables:** Phoenix requires `SECRET_KEY_BASE` and `DATABASE_URL`
3. **Database Initialization:** PostgreSQL needs explicit database creation or automation
4. **CMD Syntax:** Use exec form for Docker CMD to avoid shell interpretation issues

### Best Practices Implemented
1. **Environment File Management:** Centralized configuration in `.env`
2. **Automated Database Setup:** Use `POSTGRES_DB` for automatic database creation
3. **Clean Volume Management:** Regular cleanup prevents corruption issues
4. **Proper Image Building:** Avoid overlaying build artifacts with host mounts

---

## Verification Commands

### Check Application Status
```bash
docker compose up
docker compose logs web
docker compose logs db
```

### Database Verification
```bash
docker exec -it hello-db-1 psql -U postgres -l  # List databases
```

### Container Health Check
```bash
docker compose ps
docker exec -it hello-web-1 ls -la bin/hello  # Verify executable
```

---

## Current Status

✅ **Application Status:** Running successfully  
✅ **Database Status:** PostgreSQL running with auto-created `hello_dev` database  
✅ **Environment Configuration:** Complete with all required variables  
✅ **Docker Configuration:** Optimized without problematic bind mounts  

### Ready for Development
The application is now fully functional and ready for normal development workflow. Future `docker compose up` commands will work reliably without manual intervention.

---

## Future Recommendations

1. **Regular Volume Cleanup:** Periodically clean Docker volumes to prevent corruption
2. **Environment Documentation:** Keep `.env.example` file for new developers
3. **Health Checks:** Consider adding health check endpoints for monitoring
4. **Backup Strategy:** Implement database backup procedures for important data

---

*Report generated automatically based on troubleshooting session*  
*Contact: Assistant support for Docker/Elixir development issues*
