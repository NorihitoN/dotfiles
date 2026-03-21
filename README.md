# dotfiles

Personal dotfiles managed with a bare git repository.

## Structure

```
~
├── .zshrc
├── .zprofile
├── .zshenv
├── .profile
├── .tmux.conf
├── .gitmodules
├── install.sh
└── .config/
    ├── aerospace/
    ├── alacritty/
    │   ├── alacritty.toml
    │   └── themes/          # submodule: alacritty/alacritty-theme
    ├── borders/
    ├── karabiner/
    ├── lazygit/
    ├── nvim/                # submodule: NorihitoN/nvim-config
    ├── sketchybar/
    └── starship.toml
```

## Install

```bash
bash <(curl -s https://raw.githubusercontent.com/NorihitoN/dotfiles/main/install.sh)
```

After installation:

1. Reload shell: `source ~/.zshrc`
2. Create `~/.zshrc.local` for machine-specific settings (not tracked):

```bash
# ~/.zshrc.local
export SOME_API_KEY="..."
```

## Daily Usage

```bash
# Check status
dotfiles status

# Add a file
dotfiles add ~/.zshrc
dotfiles commit -m "update zshrc"
dotfiles push

# Show diff
dotfiles diff
```

## Not Tracked

The following are intentionally excluded:

- `~/.gitconfig` — contains work-specific name/email
- `~/.zshrc.local` — machine/work-specific env vars
- `~/.config/gh/hosts.yml` — GitHub auth token
- `~/.config/github-copilot/apps.json` — Copilot auth token
