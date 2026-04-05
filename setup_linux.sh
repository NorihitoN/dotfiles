#!/usr/bin/env bash
# Linux (WSL2/Ubuntu) environment setup script
# Usage: bash setup_linux.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}==>${NC} $1"; }
warn()  { echo -e "${YELLOW}Warning:${NC} $1"; }

ARCH=$(uname -m)  # x86_64 or aarch64

# ============================================================
# System packages
# ============================================================
info "Updating system packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
  curl wget git zsh tmux unzip \
  build-essential pkg-config \
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
  libsqlite3-dev libncursesw5-dev libffi-dev liblzma-dev

# ============================================================
# CLI tools via apt
# ============================================================
info "Installing CLI tools via apt..."
sudo apt install -y fzf ripgrep

# bat (Ubuntu registers as batcat due to naming conflict)
sudo apt install -y bat 2>/dev/null || true
sudo ln -sf /usr/bin/batcat /usr/local/bin/bat 2>/dev/null || true

# fd (Ubuntu registers as fdfind)
sudo apt install -y fd-find 2>/dev/null || true
sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd 2>/dev/null || true

# ============================================================
# GitHub CLI
# ============================================================
if ! command -v gh &>/dev/null; then
  info "Installing GitHub CLI..."
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update && sudo apt install -y gh
fi

# ============================================================
# Neovim (binary tarball)
# ============================================================
if ! command -v nvim &>/dev/null; then
  info "Installing Neovim..."
  if [[ "$ARCH" == "aarch64" ]]; then
    NVIM_ARCHIVE="nvim-linux-arm64.tar.gz"
  else
    NVIM_ARCHIVE="nvim-linux-x86_64.tar.gz"
  fi
  curl -LO "https://github.com/neovim/neovim/releases/latest/download/${NVIM_ARCHIVE}"
  sudo tar -C /opt -xzf "${NVIM_ARCHIVE}"
  sudo ln -sf /opt/nvim-linux-*/bin/nvim /usr/local/bin/nvim
  rm "${NVIM_ARCHIVE}"
fi

# ============================================================
# eza
# ============================================================
if ! command -v eza &>/dev/null; then
  info "Installing eza..."
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
    | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
    | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt update && sudo apt install -y eza
fi

# ============================================================
# git-delta
# ============================================================
if ! command -v delta &>/dev/null; then
  info "Installing git-delta..."
  DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" \
    | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
  if [[ "$ARCH" == "aarch64" ]]; then
    DELTA_PKG="git-delta_${DELTA_VERSION}_arm64.deb"
  else
    DELTA_PKG="git-delta_${DELTA_VERSION}_amd64.deb"
  fi
  curl -LO "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/${DELTA_PKG}"
  sudo dpkg -i "${DELTA_PKG}"
  rm "${DELTA_PKG}"
fi

# ============================================================
# lazygit
# ============================================================
if ! command -v lazygit &>/dev/null; then
  info "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
    | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
  if [[ "$ARCH" == "aarch64" ]]; then
    LAZYGIT_ARCH="arm64"
  else
    LAZYGIT_ARCH="x86_64"
  fi
  curl -Lo lazygit.tar.gz \
    "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm lazygit lazygit.tar.gz
fi

# ============================================================
# lazydocker
# ============================================================
if ! command -v lazydocker &>/dev/null; then
  info "Installing lazydocker..."
  curl -fsSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
fi

# ============================================================
# procs
# ============================================================
if ! command -v procs &>/dev/null; then
  info "Installing procs..."
  PROCS_VERSION=$(curl -s "https://api.github.com/repos/dalance/procs/releases/latest" \
    | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
  if [[ "$ARCH" == "aarch64" ]]; then
    PROCS_ARCHIVE="procs-v${PROCS_VERSION}-aarch64-linux.zip"
  else
    PROCS_ARCHIVE="procs-v${PROCS_VERSION}-x86_64-linux.zip"
  fi
  curl -LO "https://github.com/dalance/procs/releases/download/v${PROCS_VERSION}/${PROCS_ARCHIVE}"
  unzip "${PROCS_ARCHIVE}" procs
  sudo install procs /usr/local/bin
  rm procs "${PROCS_ARCHIVE}"
fi

# ============================================================
# starship
# ============================================================
if ! command -v starship &>/dev/null; then
  info "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

# ============================================================
# zoxide
# ============================================================
if ! command -v zoxide &>/dev/null; then
  info "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# ============================================================
# Docker Engine
# ============================================================
if ! command -v docker &>/dev/null; then
  info "Installing Docker Engine..."
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker "$USER"
  warn "Docker installed. Log out and back in to use without sudo."
fi

# ============================================================
# Language managers
# ============================================================

# Rust (rustup)
if ! command -v rustup &>/dev/null; then
  info "Installing rustup (Rust)..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

# Python (uv)
if ! command -v uv &>/dev/null; then
  info "Installing uv (Python)..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Haskell (ghcup)
if ! command -v ghcup &>/dev/null; then
  info "Installing ghcup (Haskell)..."
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org \
    | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 sh
fi

# Node (nvm)
if [ ! -d "$HOME/.nvm" ]; then
  info "Installing nvm (Node)..."
  NVM_VERSION=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" \
    | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
fi

# Scala (coursier)
if ! command -v cs &>/dev/null; then
  info "Installing coursier (Scala)..."
  if [[ "$ARCH" == "aarch64" ]]; then
    curl -fL "https://github.com/coursier/launchers/raw/master/cs-aarch64-pc-linux.gz" | gzip -d > cs
  else
    curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d > cs
  fi
  chmod +x cs
  ./cs setup --yes
  rm cs
fi

# ============================================================
# Oh My Zsh + plugins
# ============================================================
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
  info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
fi

if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
  info "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
fi

# ============================================================
# Change default shell to zsh
# ============================================================
if [ "$SHELL" != "$(command -v zsh)" ]; then
  info "Changing default shell to zsh..."
  chsh -s "$(command -v zsh)"
fi

echo ""
info "Done!"
echo ""
echo "Next steps:"
echo "  1. Install dotfiles: bash <(curl -fsSL https://raw.githubusercontent.com/NorihitoN/dotfiles/main/install.sh)"
echo "  2. Restart shell: exec zsh"
echo "  3. Install Node LTS: nvm install --lts"
echo "  4. Install GHC: ghcup install ghc && ghcup install cabal"
