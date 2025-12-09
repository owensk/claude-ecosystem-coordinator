# Claude Ecosystem Coordinator

Orchestration and Docker Compose configuration for Claude ecosystem services.

## Overview

This repository provides the infrastructure to run all Claude ecosystem plugins as containerized services. It enables:

- **Local Development**: Run services in Docker containers for consistent environments
- **Service Discovery**: Configuration files for service-to-service communication
- **MCP Integration**: Connect Claude Code to containerized ecosystem services

## Quick Start

```bash
# Start all services
./scripts/dev-up.sh

# Check service status
./scripts/dev-status.sh

# View logs
./scripts/dev-logs.sh

# Stop services
./scripts/dev-down.sh
```

## Services

| Service | gRPC Port | REST Port | MCP Port |
|---------|-----------|-----------|----------|
| feature-registry | 50051 | 8080 | 9000 |
| ecosystem-core | 50052 | 8081 | 9001 |
| claude-arena | 50053 | 8082 | 9002 |
| sdlc-workflow-manager | 50054 | 8083 | 9003 |
| test-manager | 50055 | 8084 | 9004 |
| async-runner | 50056 | 8085 | 9005 |

## Directory Structure

```
claude-ecosystem-coordinator/
├── compose/              # Docker Compose files
│   └── docker-compose.yml
├── configs/              # Service configuration
│   ├── services-local.yaml
│   ├── services-docker.yaml
│   └── mcp-servers.json.template
├── scripts/              # Development scripts
│   ├── dev-up.sh
│   ├── dev-down.sh
│   ├── dev-logs.sh
│   └── dev-status.sh
├── docs/                 # Documentation
└── tests/                # Integration tests
```

## Configuration

### Service Discovery

Two configuration modes:

- `services-local.yaml`: For local development (localhost ports)
- `services-docker.yaml`: For Docker Compose (container names)

Set `ECOSYSTEM_CONFIG` environment variable to select:

```bash
export ECOSYSTEM_CONFIG=docker  # or 'local'
```

### Claude Code MCP Integration

Generate MCP config for Claude Code:

```bash
./scripts/generate-mcp-config.sh docker > ~/.claude/mcp-servers.json
```

## Requirements

- Docker 20.10+
- Docker Compose 2.0+
- Python 3.11+ (for local development)

## License

MIT
