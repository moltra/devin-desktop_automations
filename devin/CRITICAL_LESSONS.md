# Critical Lessons Learned

> **Note:** Replace placeholder values like `<container-name>`, `<service-name>`, `<port>`, and `<mount-path>` with actual values from your environment.

## 🚨 Most Important Rules

### ALWAYS TEST BEFORE MERGING
- **Never merge untested code into the project**
- Always test changes on a separate branch first
- Verify functionality works as expected
- Check for regressions in existing features
- Only merge to main after successful testing
- This prevents breaking the main branch

### NEVER Change Docker Network Configuration Without Testing
- Changing networks breaks inter-container communication
- Always test in separate environment first
- Always have rollback plan ready
- Document network dependencies clearly

## 🔧 Docker Configuration Mistakes Made

### Mistake 1: Changed Network Without Understanding Impact
- **What happened:** Changed from custom network to default network
- **Impact:** Broke communication with ollama and alltalk-dev
- **Lesson:** Understand existing network architecture before changing

### Mistake 2: Port Conflict Not Checked
- **What happened:** Port 8089 conflicted with paperless-gpt
- **Impact:** Container failed to start
- **Lesson:** Always check port availability with `docker ps` before changing

### Mistake 3: Config Mount Path Issues
- **What happened:** Used external path that was a directory, not a file
- **Impact:** Mount error, container wouldn't start
- **Lesson:** Verify mount paths exist and are correct type (file vs directory)

## ✅ Correct Approach for Configuration Changes

### Docker Setup Overview
- **Main compose file**: `/mnt/samsungssd/docker/docker-compose-mark-B550-GAMING-X.yml`
- **Service definition**: `/mnt/samsungssd/docker/compose/mark-B550-GAMING-X/moneyprinterturbo-dev.yml`
- **Code mounted as volume**: `${MPT_REPO_DIR:-/mnt/samsungssd/repo/MoneyPrinterTurbo-openai-tts}:/MoneyPrinterTurbo`
- **Important**: Code changes are immediately available inside containers - only restart needed, no rebuild required

### Step 1: Check Current State
```bash
docker ps | grep moneyprinterturbo
docker network ls
docker inspect moneyprinterturbo-dev-api | grep Networks
```

### Step 2: Check Port Availability
```bash
# Replace <port> with actual port number (e.g., 8092)
docker ps | grep 8092
```

### Step 3: Verify Mount Paths
```bash
# Replace <mount-path> with actual path (e.g., /mnt/samsungssd/repo/MoneyPrinterTurbo-openai-tts/config.toml)
ls -la /mnt/samsungssd/repo/MoneyPrinterTurbo-openai-tts/config.toml
```

### Step 4: Make Changes
```bash
# Edit configuration file
# Test locally
cd /mnt/samsungssd/docker
docker compose -f docker-compose-mark-B550-GAMING-X.yml config
```

### Step 5: Deploy with Rollback Plan
```bash
set -e  # Exit on any error

# Backup
cd /mnt/samsungssd/docker
docker compose -f docker-compose-mark-B550-GAMING-X.yml config > backup.yml
if [ -f backup.yml ]; then
    echo "✓ Configuration backed up to backup.yml"
else
    echo "❌ ERROR: Backup failed"
    exit 1
fi

# Deploy
docker compose -f docker-compose-mark-B550-GAMING-X.yml down
docker compose -f docker-compose-mark-B550-GAMING-X.yml up -d

# Verify
docker ps
docker logs moneyprinterturbo-dev-api --tail 20
```

### Step 6: Test Inter-Container Communication
```bash
# Test API from webui container
docker exec moneyprinterturbo-dev-webui curl --connect-timeout 10 --max-time 30 http://moneyprinterturbo-dev-api:8080/health

# Test ollama connectivity
docker exec moneyprinterturbo-dev-webui curl --connect-timeout 10 --max-time 30 http://ollama:11434/api/tags

# Test alltalk connectivity
docker exec moneyprinterturbo-dev-webui curl --connect-timeout 10 --max-time 30 http://alltalk-dev:7851/api/info
```

## 🔄 Restarting Containers After Code Changes

### When to Restart Only (Fast, ~2-5 seconds)
- Python code changes (`.py` files)
- Configuration file changes
- Static file changes

### When to Rebuild (Slow, ~1-2 minutes)
- Changes to `Dockerfile`
- Changes to `requirements.txt` or dependencies
- Changes to environment variables in compose file
- New system packages needed

### Restart Commands

**For WebUI changes (e.g., `webui/components/tts_provider_config.py`):**
```bash
cd /mnt/samsungssd/docker
docker compose -f docker-compose-mark-B550-GAMING-X.yml restart moneyprinterturbo-dev-webui
```

**For API changes:**
```bash
cd /mnt/samsungssd/docker
docker compose -f docker-compose-mark-B550-GAMING-X.yml restart moneyprinterturbo-dev-api
```

**For both:**
```bash
cd /mnt/samsungssd/docker
docker compose -f docker-compose-mark-B550-GAMING-X.yml restart moneyprinterturbo-dev-api moneyprinterturbo-dev-webui
```

**Verify restart:**
```bash
docker compose -f docker-compose-mark-B550-GAMING-X.yml ps moneyprinterturbo-dev-webui
```

## 🎯 Current Working Configuration

### Network
- **Name:** `docker_default` (external)
- **Purpose:** Shared with ollama and alltalk-dev
- **Status:** ✅ Working correctly

### Ports
- **API:** 8092:8080
- **WebUI:** 8502:8501
- **Ollama:** 11434
- **AllTalk:** 7851-7852

### Services on Same Network
- moneyprinterturbo-dev-api
- moneyprinterturbo-dev-webui
- ollama
- alltalk-dev

### Docker Compose Structure
- **Main file**: `/mnt/samsungssd/docker/docker-compose-mark-B550-GAMING-X.yml`
- **Service file**: `/mnt/samsungssd/docker/compose/mark-B550-GAMING-X/moneyprinterturbo-dev.yml`
- **Working directory**: `/mnt/samsungssd/docker` (for docker compose commands)
- **Code mount**: `${MPT_REPO_DIR:-/mnt/samsungssd/repo/MoneyPrinterTurbo-openai-tts}:/MoneyPrinterTurbo`

## 🔍 Debugging Network Issues

### Check Container Network
```bash
docker inspect <container-name> | grep -A 10 Networks
```

### Check DNS Resolution
```bash
# Method 1: Using getent (more reliable, available in most containers)
docker exec <container-name> getent hosts <service-name>

# Method 2: Using ping (fallback if getent not available)
docker exec <container-name> ping -c 1 <service-name>
```

### Test Connectivity
```bash
docker exec <container-name> curl --connect-timeout 10 --max-time 30 http://<service-name>:<port>
```

## 📋 Pre-Change Checklist

Before making any Docker configuration changes:

- [ ] Checked current network configuration
- [ ] Verified port availability
- [ ] Confirmed mount paths exist and are correct type
- [ ] Tested configuration with `docker compose config`
- [ ] Backed up current configuration
- [ ] Have rollback plan ready
- [ ] Documented the change
- [ ] Tested in isolated environment if possible

## 🚨 Rollback Procedure

If something breaks after configuration change:

```bash
set -e  # Exit on any error

# 1. Stop containers
cd /mnt/samsungssd/docker
docker compose -f docker-compose-mark-B550-GAMING-X.yml down

# 2. Restore configuration
if [ -f backup.yml ]; then
    cp backup.yml compose/mark-B550-GAMING-X/moneyprinterturbo-dev.yml
    echo "✓ Configuration restored from backup.yml"
else
    echo "❌ ERROR: backup.yml not found. Cannot rollback."
    exit 1
fi

# 3. Restart
docker compose -f docker-compose-mark-B550-GAMING-X.yml up -d

# 4. Verify
docker ps
docker logs moneyprinterturbo-dev-api --tail 20
```

## 💡 Key Takeaways

1. **TEST BEFORE MERGING** - This is the most important rule. Never merge untested code.
2. **Network stability is critical** - don't change it without thorough testing
3. **Port conflicts are common** - always check before changing
4. **Mount paths must be verified** - file vs directory matters
5. **Inter-container communication is fragile** - test after every network change
6. **Always have a rollback plan** - configuration changes can break everything
7. **Document everything** - future you will thank present you
8. **Use environment variables** - don't hardcode IPs, ports, or paths that might change
9. **Add error handling to scripts** - use `set -e` to catch failures early
10. **Add timeouts to network commands** - prevent scripts from hanging indefinitely
11. **Know when to restart vs rebuild** - Code changes only need restart (fast), dependency changes need rebuild (slow)
12. **Use correct docker compose file** - Main file is `/mnt/samsungssd/docker/docker-compose-mark-B550-GAMING-X.yml`, run commands from `/mnt/samsungssd/docker`
13. **Code is mounted as volume** - Changes to Python files are immediately available inside containers
