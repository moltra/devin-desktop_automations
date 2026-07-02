# MoneyPrinterTurbo Development Guide

## Critical Configuration

### Docker Network Configuration
- **Network:** `docker_default` (external network from existing stack)
- **Purpose:** Enables communication with ollama and alltalk-dev containers
- **Rule:** NEVER change network configuration without testing and rollback plan

### Port Mappings
- **API:** 8095:8080 (changed from 8089 due to paperless-gpt conflict)
- **WebUI:** 8502:8501
- **Ollama:** 11434 (existing service)
- **AllTalk:** 7851-7852 (existing service)

### Service Communication
- **API URL (internal):** `http://moneyprinterturbo-dev-api:8080`
- **API URL (external):** `http://${HOST_IP:-192.168.0.116}:8095` (use environment variable)
- **Ollama:** `http://ollama:11434`
- **AllTalk:** `http://alltalk-dev:7851`

## AllTalk TTS Integration

### Working Configuration
- **Provider:** OpenAI TTS (or OpenAI-compatible)
- **Base URL:** `http://alltalk-dev:7851/v1`
- **API Key:** Optional for AllTalk (self-hosted)
- **Voice Discovery:** Works when on same network as AllTalk
- **Voice Selection:** Manual entry required if DNS issues

### Key Features Implemented
- ✅ AllTalk v2 detection based on URL
- ✅ API key made optional for AllTalk
- ✅ Model selection hidden for AllTalk
- ✅ Voice selector shown for AllTalk
- ✅ OpenAI-compatible API support

### Known Issues
- Voice discovery may fail if DNS resolution issues between networks
- Model file errors in AllTalk (configuration issue, not code)

## Quality Rating System

### Implementation
- **File:** `app/services/quality_analyzer.py`
- **Analysis:** FFprobe (video) + Librosa (audio)
- **Scoring:** 0-100 scale with weighted average
- **Integration:** Automatic after video generation
- **UI Display:** Task Browser with color-coded badges

### Dependencies Added
- `librosa>=0.10.0`
- `soundfile>=0.12.0`
- `numpy>=1.24.0`

### Scoring Criteria
- **Video (60% weight):** Resolution, FPS, Bitrate, Codec
- **Audio (40% weight):** Sample rate, Bitrate, Channels, Codec, Clipping, Dynamic range

## Critical Rules

### Docker Configuration Changes
1. **NEVER** change network configuration without:
   - Testing in separate environment first
   - Documenting the change
   - Having rollback plan ready

2. **ALWAYS** test container startup after:
   - Changing ports
   - Adding new services
   - Modifying volume mounts

3. **BACKUP** before:
   - Major configuration changes
   - Database migrations
   - Dependency updates

### Code Quality
- Commit frequently with descriptive messages
- Atomic changes (one feature per commit)
- Test compilation before committing
- Monitor logs for errors after deployment

## Safe Deployment Process

### Pre-Deployment Checklist
```bash
set -e  # Exit on any error

# 1. Backup current state
docker compose -f moneyprinterturbo-dev.yml config > backup-config.yml
echo "✓ Configuration backed up"

# 2. Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  WARNING: You have uncommitted changes. Stash or commit them first."
    read -p "Continue anyway? (y/N): " -n 1 -r
    [[ $REPLY =~ ^[Yy]$ ]] || exit 1
fi

# 3. Pull latest
git pull MoneyPrinterTurbo-openai-tts main

# 4. Rebuild
docker compose -f moneyprinterturbo-dev.yml build --no-cache

# 5. Restart
docker compose -f moneyprinterturbo-dev.yml down
docker compose -f moneyprinterturbo-dev.yml up -d

# 6. Verify
docker ps | grep moneyprinterturbo
docker logs moneyprinterturbo-dev-api --tail 20
curl --connect-timeout 10 --max-time 30 http://${HOST_IP:-192.168.0.116}:8095/health || echo "⚠️  Health check failed"
```

### Rollback Plan
```bash
set -e  # Exit on any error

# 1. Stop containers
docker compose -f moneyprinterturbo-dev.yml down

# 2. Restore configuration
if [ -f backup-config.yml ]; then
    cp backup-config.yml moneyprinterturbo-dev.yml
    echo "✓ Configuration restored"
else
    echo "❌ ERROR: backup-config.yml not found"
    exit 1
fi

# 3. Git rollback (optional - comment out if not needed)
# git checkout <previous-commit>

# 4. Restart
docker compose -f moneyprinterturbo-dev.yml up -d

# 5. Verify
docker ps | grep moneyprinterturbo
docker logs moneyprinterturbo-dev-api --tail 20
curl --connect-timeout 10 --max-time 30 http://${HOST_IP:-192.168.0.116}:8095/health || echo "⚠️  Health check failed"
```

## Testing Strategy

### Local Testing
```bash
set -e  # Exit on any error

# Code quality
python3 -m py_compile app/services/quality_analyzer.py

# Docker build
docker compose -f moneyprinterturbo-dev.yml build

# Health checks (set HOST_IP environment variable if different from default)
curl --connect-timeout 10 --max-time 30 http://${HOST_IP:-192.168.0.116}:8095/health
curl -s --connect-timeout 10 --max-time 30 http://${HOST_IP:-192.168.0.116}:8502 | head -5
```

### Integration Testing
- Test AllTalk voice discovery
- Test Ollama connectivity
- Test video generation end-to-end
- Test quality rating system

## Log Locations

### Container Logs
```bash
docker logs moneyprinterturbo-dev-api -f
docker logs moneyprinterturbo-dev-webui -f
```

### Application Logs
- `/mnt/data/storage/logs/` (if configured)
- Docker container logs (stdout/stderr)

## Recent Commits Reference

### Quality Rating System
- `f9701b3` feat: Add automatic video and audio quality rating system

### AllTalk Integration
- `d711769` fix: Make OpenAI-style TTS work with AllTalk (no API key required)
- `e60207a` fix: Update AllTalk voice fetching to use correct endpoint and handle response formats

### Docker Configuration
- `f199410` fix: Update Docker network configuration to use existing stack network

## Development Workflow

### Branch Strategy
- `main` - Production-ready, stable code
- `develop` - Integration testing, feature development
- `feature/*` - Individual features
- `bugfix/*` - Bug fixes
- `hotfix/*` - Emergency production fixes

### Daily Workflow
```bash
# Morning
git pull MoneyPrinterTurbo-openai-tts main
docker compose -f moneyprinterturbo-dev.yml pull
docker compose -f moneyprinterturbo-dev.yml up -d

# Development
git checkout -b feature/new-feature
# Make changes and test
git add .
git commit -m "feat: description"
git push MoneyPrinterTurbo-openai-tts feature/new-feature
```

## Environment Variables

### Current Configuration
- `MPT_REPO_DIR=/mnt/samsungssd/repo/MoneyPrinterTurbo-openai-tts`
- `DOCKERDIR=/home/user/docker`
- `TZ=America/New_York` (use system default or set to your timezone)
- `PUID=1000`
- `PGID=1000`
- `HOST_IP=192.168.0.116` (set to your server's IP for external access)

## Important Notes

### Network Dependencies
- MoneyPrinterTurbo requires access to `docker_default` network
- Must be able to resolve `ollama` and `alltalk-dev` container names
- Network changes break inter-container communication

### Port Conflicts
- Port 8089 was conflicting with paperless-gpt
- Changed to 8095 for API service
- Always check port availability before changing

### Configuration Mounts
- Config file mounted from repo directory: `${MPT_REPO_DIR}/config.toml`
- Storage mounted from: `/mnt/data/storage`
- Cache volume: `moneyprinterturbo-dev-cache`
