#!/bin/bash
set -euo pipefail

# Only run in remote (Claude Code on the web) environments
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

echo "Session start hook running..."

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(git -C "$(dirname "$0")" rev-parse --show-toplevel 2>/dev/null || pwd)}"
cd "$PROJECT_DIR"

# Install Node dependencies if package.json exists
if [ -f "package.json" ]; then
  echo "Installing Node.js dependencies..."
  npm install
fi

# Install Python dependencies if requirements.txt exists
if [ -f "requirements.txt" ]; then
  echo "Installing Python dependencies..."
  pip install -r requirements.txt --quiet
fi

# Install Python dependencies via pyproject.toml
if [ -f "pyproject.toml" ] && [ ! -f "requirements.txt" ]; then
  echo "Installing Python dependencies via pyproject.toml..."
  pip install -e ".[dev]" --quiet 2>/dev/null || pip install -e . --quiet
fi

echo "Session start hook complete."
