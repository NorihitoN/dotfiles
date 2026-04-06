# dotfiles

Personal dotfiles managed with a bare git repository.

## Why Bare Git

3つの管理方法を比較した結果、Bare Git を採用。

| | Bare Git | GNU Stow | Chezmoi |
|---|---|---|---|
| ファイルの場所 | 変わらない | 移動が必要 | コピーを持つ |
| 追加ツール | 不要 | stow が必要 | chezmoi が必要 |
| ディレクトリ設計 | 不要 | 必要 | 不要 |
| マシン別差分 | 難しい | 難しい | 得意 |
| シークレット管理 | なし | なし | あり |
| 学習コスト | 低 | 低〜中 | 高 |

**選定理由:**
- ファイルを元の場所から移動しなくてよい
- git 以外の追加ツールが不要
- 学習コストが低くすぐに始められる

将来的に複数マシン間での差分管理やシークレット管理が必要になった場合は Chezmoi への移行も可能。

## Setup

### macOS（新しいMacのセットアップ）

**1. Homebrew をインストール**

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**2. dotfiles をセットアップ**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/NorihitoN/dotfiles/main/install.sh)
```

**3. パッケージを一括インストール**

```bash
brew bundle install --file=~/Brewfile
```

**4. 初回セットアップを実行**

```bash
~/post_install.sh
```

`atuin` が入っていてまだ履歴DBがなければ、ここで `atuin import auto` を一度だけ実行します。

**5. 後処理**

```bash
source ~/.zshrc
touch ~/.zshrc.local  # マシン固有の設定ファイルを作成
```

---

### Linux / WSL2（Ubuntu）

**1. セットアップスクリプトを実行**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/NorihitoN/dotfiles/main/setup_linux.sh)
```

インストール内容:
- CLI ツール: `neovim`, `tmux`, `lazygit`, `bat`, `eza`, `fd`, `ripgrep`, `fzf`, `procs`, `git-delta`, `gh`, `starship`, `zoxide`, `lazydocker`
- Docker Engine
- 言語マネージャー: `rustup` / `uv` / `ghcup` / `nvm` / `coursier`
- Oh My Zsh + `zsh-autosuggestions` / `zsh-syntax-highlighting`

**2. dotfiles をセットアップ**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/NorihitoN/dotfiles/main/install.sh)
```

**3. 後処理**

```bash
~/post_install.sh

exec zsh

nvm install --lts        # Node (LTS)
ghcup install ghc        # Haskell GHC
ghcup install cabal      # Haskell Cabal

touch ~/.zshrc.local     # マシン固有の設定ファイルを作成
```

---

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
