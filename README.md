# Dotfiles

Personal configuration files for **githop**'s development environment across various platforms, focused on a productive terminal-centric workflow with the [Kanagawa](https://github.com/rebelot/kanagawa.nvim) color scheme.

## 🚀 Quick Start

On a new Mac, run a single command to bootstrap the entire setup (installs Homebrew, clones this repo to `~/.config`, and installs all tools):

```bash
curl -fsSL https://raw.githubusercontent.com/githop/config/main/setup.sh | bash
```

Or manually:

```bash
git clone https://github.com/githop/config ~/.config
~/.config/setup.sh
```

The script is idempotent — it's safe to re-run if interrupted.

## 🛠 Components

### 🐚 Shell (Zsh)
Managed with [Zinit](https://github.com/zdharma-continuum/zinit) for high performance and modularity.
- **Prompt:** [Starship](https://starship.rs/)
- **Navigation:** `zoxide` (aliased to `j`)
- **Modern CLI Tools:** `eza` (enhanced ls), `bat` (syntax-highlighted cat), `fd`, `ripgrep`, and `delta`.
- **Modularity:** Custom logic is split into standalone scripts in `zsh/scripts/`.

### 📝 Editor (Neovim)
A high-performance Neovim setup based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
- Optimized for LSP, treesitter, and telescope.
- Custom plugins are maintained in `nvim/lua/custom/plugins/`.

### 🖥 Terminal Emulators
Configuration files for several modern terminal emulators, ensuring a consistent look and feel across platforms:
- **Ghostty**: Native-speed performance.
- **Kitty**: GPU-accelerated and feature-rich.
- **WezTerm**: Highly configurable via Lua.

### 🎨 Theme & Fonts
- **Color Scheme:** Kanagawa Dragon (dark, high-contrast variant).
- **Typography:** [IosevkaTerm Nerd Font Mono](https://github.com/ryanoasis/nerd-fonts) (Medium weight, 20.5pt).

## 📁 Structure

- `bat/`: `bat` syntax highlighting themes.
- `ghostty/`: Configuration and themes for Ghostty.
- `kitty/`: Layouts and themes for Kitty.
- `nvim/`: Neovim configuration (`init.lua`).
- `wezterm/`: WezTerm logic and color schemes.
- `zsh/`: Main `.zshrc` and modular shell scripts.
- `opencode/`: Configuration for the OpenCode CLI agent.
