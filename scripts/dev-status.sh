#!/bin/bash
# Show status of ecosystem services
# Usage: ./dev-status.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_DIR="$(dirname "$SCRIPT_DIR")/compose"

cd "$COMPOSE_DIR"

echo "=== Container Status ==="
docker compose -f docker-compose.yml ps

echo ""
echo "=== Health Checks ==="

# Check each service health
SERVICES="redis feature-registry ecosystem-core claude-arena sdlc-workflow-manager test-manager async-runner"

for service in $SERVICES; do
    container="ecosystem-${service}"
    if [ "$service" = "redis" ]; then
        container="ecosystem-redis"
    elif [ "$service" = "ecosystem-core" ]; then
        container="ecosystem-core"
    fi

    status=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null || echo "not running")

    case $status in
        healthy)
            echo "  $service: ✓ healthy"
            ;;
        unhealthy)
            echo "  $service: ✗ unhealthy"
            ;;
        starting)
            echo "  $service: ⋯ starting"
            ;;
        *)
            echo "  $service: - not running"
            ;;
    esac
done

echo ""
echo "=== Port Mappings ==="
docker compose -f docker-compose.yml ps --format "table {{.Name}}\t{{.Ports}}"
