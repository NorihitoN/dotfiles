#!/usr/bin/env bash
# Dotfiles install script
# Usage: bash install.sh

set -e

DOTFILES_REPO="git@github.com:NorihitoN/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

echo "==> Setting up dotfiles..."

# Check if already initialized
if [ -d "$DOTFILES_DIR" ]; then
  echo "Error: $DOTFILES_DIR already exists. Aborting."
  exit 1
fi

# Clone bare repository
echo "==> Cloning bare repository..."
git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"

# Define dotfiles command
dotfiles() {
  git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

# Configure
dotfiles config status.showUntrackedFiles no
dotfiles config user.name "NorihitoN"
dotfiles config user.email "norihito0626@gmail.com"

# Checkout dotfiles (backup conflicts if any)
echo "==> Checking out dotfiles..."
if ! dotfiles checkout 2>/dev/null; then
  echo "==> Backing up conflicting files to $BACKUP_DIR ..."
  mkdir -p "$BACKUP_DIR"
  dotfiles checkout 2>&1 \
    | grep "^\s" \
    | awk '{print $1}' \
    | while read -r file; do
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        mv "$HOME/$file" "$BACKUP_DIR/$file"
      done
  dotfiles checkout
fi

# Initialize submodules
echo "==> Initializing submodules..."
dotfiles submodule update --init --recursive

echo ""
echo "Done! Dotfiles are set up."
echo ""
echo "Next steps:"
echo "  1. Run: source ~/.zshrc"
echo "  2. Create ~/.zshrc.local for machine-specific settings"
