#!/bin/bash
# View logs from ecosystem services
# Usage: ./dev-logs.sh [--follow] [--tail N] [service...]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_DIR="$(dirname "$SCRIPT_DIR")/compose"

# Parse arguments
FOLLOW_FLAG=""
TAIL_FLAG=""
SERVICES=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --follow|-f)
            FOLLOW_FLAG="--follow"
            shift
            ;;
        --tail|-n)
            TAIL_FLAG="--tail $2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [--follow] [--tail N] [service...]"
            echo ""
            echo "Options:"
            echo "  --follow, -f   Follow log output"
            echo "  --tail N, -n N Show last N lines"
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

cd "$COMPOSE_DIR"

docker compose -f docker-compose.yml logs $FOLLOW_FLAG $TAIL_FLAG $SERVICES
