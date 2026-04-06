#!/usr/bin/env bash
# Post-install setup for tools that need one-time initialization

set -euo pipefail

ATUIN_HISTORY_DB="${HOME}/.local/share/atuin/history.db"

echo "==> Running post-install setup..."

if command -v atuin >/dev/null 2>&1; then
  if [ ! -f "$ATUIN_HISTORY_DB" ]; then
    echo "==> Importing existing shell history into atuin..."
    atuin import auto
  else
    echo "==> Skipping atuin import (history DB already exists)"
  fi
else
  echo "==> Skipping atuin setup (atuin is not installed)"
fi

echo "==> Post-install setup complete."
