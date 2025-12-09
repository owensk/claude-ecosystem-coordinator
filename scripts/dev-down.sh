#!/bin/bash
# Stop all ecosystem services
# Usage: ./dev-down.sh [--volumes] [--remove-orphans]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_DIR="$(dirname "$SCRIPT_DIR")/compose"

# Parse arguments
VOLUMES_FLAG=""
ORPHANS_FLAG=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --volumes|-v)
            VOLUMES_FLAG="--volumes"
            shift
            ;;
        --remove-orphans)
            ORPHANS_FLAG="--remove-orphans"
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--volumes] [--remove-orphans]"
            echo ""
            echo "Options:"
            echo "  --volumes, -v      Remove named volumes (WARNING: deletes data)"
            echo "  --remove-orphans   Remove containers for undefined services"
            echo "  --help, -h         Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "Stopping ecosystem services..."

cd "$COMPOSE_DIR"

docker compose -f docker-compose.yml down $VOLUMES_FLAG $ORPHANS_FLAG

echo "Services stopped."

if [ -n "$VOLUMES_FLAG" ]; then
    echo "Volumes removed."
fi
