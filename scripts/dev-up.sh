#!/bin/bash
# Start all ecosystem services with Docker Compose
# Usage: ./dev-up.sh [--build] [--detach] [service...]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_DIR="$(dirname "$SCRIPT_DIR")/compose"
COMPOSE_FILE="$COMPOSE_DIR/docker-compose.yml"

# Parse arguments
BUILD_FLAG=""
DETACH_FLAG="-d"
SERVICES=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --build|-b)
            BUILD_FLAG="--build"
            shift
            ;;
        --attach|-a)
            DETACH_FLAG=""
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--build] [--attach] [service...]"
            echo ""
            echo "Options:"
            echo "  --build, -b    Rebuild images before starting"
            echo "  --attach, -a   Run in foreground (don't detach)"
            echo "  --help, -h     Show this help message"
            echo ""
            echo "Services:"
            echo "  redis, feature-registry, ecosystem-core, claude-arena,"
            echo "  sdlc-workflow-manager, test-manager, async-runner"
            exit 0
            ;;
        *)
            SERVICES="$SERVICES $1"
            shift
            ;;
    esac
done

echo "Starting ecosystem services..."
echo "Compose file: $COMPOSE_FILE"

cd "$COMPOSE_DIR"

if [ -n "$BUILD_FLAG" ]; then
    echo "Building images..."
    docker compose -f docker-compose.yml build $SERVICES
fi

echo "Starting containers..."
docker compose -f docker-compose.yml up $DETACH_FLAG $SERVICES

if [ -n "$DETACH_FLAG" ]; then
    echo ""
    echo "Services started in background."
    echo "Use './dev-status.sh' to check health."
    echo "Use './dev-logs.sh' to view logs."
    echo "Use './dev-down.sh' to stop."
fi
