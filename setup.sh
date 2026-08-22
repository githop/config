#!/usr/bin/env bash
# Bootstrap script for setting up this dotfiles config on a new Mac.
# Usage: run from anywhere; it clones the repo to ~/.config if not already there.

set -euo pipefail

REPO_URL="https://github.com/githop/config.git"
CONFIG_DIR="$HOME/.config"

log() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }

# Re-attach to the terminal when run via `curl | bash` (stdin is the pipe,
# so interactive prompts like Homebrew's sudo request would fail otherwise)
if [[ ! -t 0 ]]; then
    SELF="$(mktemp)"
    cat >"$SELF"
    chmod +x "$SELF"
    exec bash "$SELF" </dev/tty
fi

# 1. Xcode Command Line Tools (provides git)
if ! xcode-select -p &>/dev/null; then
    log "Installing Xcode Command Line Tools"
    xcode-select --install
    echo "Re-run this script once the installation finishes."
    exit 1
fi

# 2. Homebrew
if ! command -v brew &>/dev/null; then
    log "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/usr/local/bin/brew shellenv 2>/dev/null || /opt/homebrew/bin/brew shellenv)"

# 3. Clone dotfiles into ~/.config (skip if already present)
if [[ ! -d "$CONFIG_DIR/.git" ]]; then
    log "Cloning dotfiles into $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
    git clone "$REPO_URL" "$CONFIG_DIR"
elif [[ "$(realpath "$CONFIG_DIR")" == "$(realpath "$(pwd)")" ]]; then
    :
else
    log "Updating existing dotfiles in $CONFIG_DIR"
    git -C "$CONFIG_DIR" pull --ff-only || true
fi

# 4. CLI tools & apps via Homebrew
# (starship, fzf, zoxide, ripgrep, bat, fd, delta are installed by zinit
# from GitHub releases, so they are intentionally NOT installed here)
log "Installing formulae and casks"
brew install neovim tmux eza gh gnupg wakeonlan uv fnm lazygit \
    jesseduffield/lazygit/lazygit
brew install --cask ghostty

# 5. Nerd Font (IosevkaTerm) used by terminal configs
log "Installing IosevkaTerm Nerd Font"
brew install --cask font-iosevka-term-nerd-font

# 6. Node.js via fnm + pnpm (used by zsh scripts)
log "Setting up Node.js (fnm)"
eval "$(fnm env)"
fnm install --lts
fnm default lts-latest
npm install -g pnpm

# 7. Point zsh at ~/.config/zsh via ZDOTDIR
log "Configuring ZDOTDIR"
if ! grep -q 'ZDOTDIR' "$HOME/.zprofile" 2>/dev/null; then
    echo 'export ZDOTDIR=~/.config/zsh' >>"$HOME/.zprofile"
fi

# 8. Zinit (zsh plugin manager; .zshrc bootstraps it on first launch too)
ZINIT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_DIR" ]]; then
    log "Installing Zinit"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_DIR"
fi

# 9. Set zsh as login shell
if [[ "$SHELL" != */zsh ]]; then
    log "Setting zsh as default shell"
    chsh -s "$(command -v zsh)"
fi

# 10. macFUSE + sshfs (installed last: needs manual System Settings approval
#     and possibly a reboot; everything else is already set up by now)
log "Installing macFUSE and sshfs (may require approval/reboot)"
if ! brew install --cask macfuse || ! brew install gromgit/fuse/sshfs; then
    echo "macFUSE/sshfs install failed — approve the system extension in"
    echo "System Settings, reboot if prompted, then re-run this script."
fi

log "Done! Open a new terminal (Ghostty recommended). Neovim plugins will auto-install via lazy.nvim on first launch."
