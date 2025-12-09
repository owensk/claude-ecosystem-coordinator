#!/bin/bash
# Generate MCP server configuration for Claude Code
# Usage: ./generate-mcp-config.sh [local|docker] > ~/.claude/mcp-servers.json

set -e

MODE="${1:-local}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")/configs"

# Load service configuration
if [ "$MODE" = "docker" ]; then
    CONFIG_FILE="$CONFIG_DIR/services-docker.yaml"
    # For Docker, MCP servers connect to exposed host ports
    FEATURE_REGISTRY_MCP_HOST="localhost"
    FEATURE_REGISTRY_MCP_PORT="9000"
    FEATURE_REGISTRY_GRPC_HOST="localhost"
    FEATURE_REGISTRY_GRPC_PORT="50051"

    ECOSYSTEM_CORE_MCP_PORT="9001"
    ECOSYSTEM_CORE_GRPC_HOST="localhost"
    ECOSYSTEM_CORE_GRPC_PORT="50052"

    CLAUDE_ARENA_MCP_PORT="9002"
    CLAUDE_ARENA_GRPC_HOST="localhost"
    CLAUDE_ARENA_GRPC_PORT="50053"

    SDLC_WORKFLOW_MCP_PORT="9003"
    SDLC_WORKFLOW_GRPC_HOST="localhost"
    SDLC_WORKFLOW_GRPC_PORT="50054"

    TEST_MANAGER_MCP_PORT="9004"
    TEST_MANAGER_GRPC_HOST="localhost"
    TEST_MANAGER_GRPC_PORT="50055"

    ASYNC_RUNNER_MCP_PORT="9005"
    ASYNC_RUNNER_GRPC_HOST="localhost"
    ASYNC_RUNNER_GRPC_PORT="50056"
else
    # Local mode - direct process execution
    FEATURE_REGISTRY_MCP_PORT="9000"
    FEATURE_REGISTRY_GRPC_HOST="localhost"
    FEATURE_REGISTRY_GRPC_PORT="50051"

    ECOSYSTEM_CORE_MCP_PORT="9001"
    ECOSYSTEM_CORE_GRPC_HOST="localhost"
    ECOSYSTEM_CORE_GRPC_PORT="50052"

    CLAUDE_ARENA_MCP_PORT="9002"
    CLAUDE_ARENA_GRPC_HOST="localhost"
    CLAUDE_ARENA_GRPC_PORT="50053"

    SDLC_WORKFLOW_MCP_PORT="9003"
    SDLC_WORKFLOW_GRPC_HOST="localhost"
    SDLC_WORKFLOW_GRPC_PORT="50054"

    TEST_MANAGER_MCP_PORT="9004"
    TEST_MANAGER_GRPC_HOST="localhost"
    TEST_MANAGER_GRPC_PORT="50055"

    ASYNC_RUNNER_MCP_PORT="9005"
    ASYNC_RUNNER_GRPC_HOST="localhost"
    ASYNC_RUNNER_GRPC_PORT="50056"
fi

PYTHON_PATH="${PYTHON_PATH:-python3}"

cat << EOF
{
  "mcpServers": {
    "feature-registry": {
      "command": "$PYTHON_PATH",
      "args": ["-m", "feature_registry.mcp.server"],
      "env": {
        "MCP_PORT": "$FEATURE_REGISTRY_MCP_PORT",
        "GRPC_HOST": "$FEATURE_REGISTRY_GRPC_HOST",
        "GRPC_PORT": "$FEATURE_REGISTRY_GRPC_PORT"
      }
    },
    "ecosystem-core": {
      "command": "$PYTHON_PATH",
      "args": ["-m", "ecosystem_core.mcp.server"],
      "env": {
        "MCP_PORT": "$ECOSYSTEM_CORE_MCP_PORT",
        "GRPC_HOST": "$ECOSYSTEM_CORE_GRPC_HOST",
        "GRPC_PORT": "$ECOSYSTEM_CORE_GRPC_PORT"
      }
    },
    "claude-arena": {
      "command": "$PYTHON_PATH",
      "args": ["-m", "claude_arena.mcp.server"],
      "env": {
        "MCP_PORT": "$CLAUDE_ARENA_MCP_PORT",
        "GRPC_HOST": "$CLAUDE_ARENA_GRPC_HOST",
        "GRPC_PORT": "$CLAUDE_ARENA_GRPC_PORT"
      }
    },
    "sdlc-workflow-manager": {
      "command": "$PYTHON_PATH",
      "args": ["-m", "sdlc_workflow_manager.mcp.server"],
      "env": {
        "MCP_PORT": "$SDLC_WORKFLOW_MCP_PORT",
        "GRPC_HOST": "$SDLC_WORKFLOW_GRPC_HOST",
        "GRPC_PORT": "$SDLC_WORKFLOW_GRPC_PORT"
      }
    },
    "test-manager": {
      "command": "$PYTHON_PATH",
      "args": ["-m", "test_manager.mcp.server"],
      "env": {
        "MCP_PORT": "$TEST_MANAGER_MCP_PORT",
        "GRPC_HOST": "$TEST_MANAGER_GRPC_HOST",
        "GRPC_PORT": "$TEST_MANAGER_GRPC_PORT"
      }
    },
    "async-runner": {
      "command": "$PYTHON_PATH",
      "args": ["-m", "async_runner.mcp.server"],
      "env": {
        "MCP_PORT": "$ASYNC_RUNNER_MCP_PORT",
        "GRPC_HOST": "$ASYNC_RUNNER_GRPC_HOST",
        "GRPC_PORT": "$ASYNC_RUNNER_GRPC_PORT"
      }
    }
  }
}
EOF
