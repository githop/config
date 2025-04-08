# Zinit setup using XDG Base Directory Specification
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Starship Prompt
zinit ice from"gh-r" as"command" atload'eval "$(starship init zsh)"'
zinit load starship/starship

setopt promptsubst

# EZA (ls replacement) with OMZ integration
zinit for \
    atinit'zstyle ":omz:plugins:eza" icons yes' \
    OMZP::eza

# Oh my zshell plugins
zinit lucid for \
    OMZP::aws \
    OMZL::git.zsh \
    OMZP::git

# Unalias grv potentially set by OMZ git plugin (run after loading)
unalias grv &> /dev/null || true

# FZF shell integration (completion & key-bindings) & fzf-git
zinit snippet https://github.com/junegunn/fzf/raw/master/shell/completion.zsh
zinit snippet https://github.com/junegunn/fzf/raw/master/shell/key-bindings.zsh
zinit snippet https://github.com/junegunn/fzf-git.sh/raw/main/fzf-git.sh

# zsh syntax highlighting, suggestions, completions
zinit wait lucid for \
  atinit"zicompinit" \
    Aloxaf/fzf-tab \
  atinit"zicompinit; zicdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

# GitHub CLI (gh) completions - only if gh is installed
# Using trigger-load'0' to load ice-defined snippet via dummy trigger
if command -v gh &> /dev/null; then
  zinit ice lucid \
      as'completion' \
      atclone:'gh completion -s zsh > _gh' \
      atpull:'%atclone' \
      src:'_gh' \
      id-as:'gh-completions' \
      trigger-load 0 # Use 0 without quotes, ensure trailing \ if not last ice
      # Add other ices above this line if needed, ensure they end in \
  zinit snippet /dev/null # Dummy snippet to trigger the ice block
fi

# Load FZF binary separately using GitHub Releases
zinit ice lucid from"gh-r" as"command" pick"fzf"
zinit load junegunn/fzf

# --- Programs loaded individually via gh-r ---

# zoxide
zinit ice lucid from"gh-r" as"command" \
    atload'eval "$(zoxide init --cmd j zsh)"' pick'zoxide/zoxide'
zinit load ajeetdsouza/zoxide

# ripgrep (rg) - Corrected pick pattern
zinit ice lucid from"gh-r" as"command" pick"*/rg"
zinit load BurntSushi/ripgrep

# bat - Corrected pick pattern
zinit ice lucid from"gh-r" as"command" pick"*/bat" \
    atload'export MANPAGER="bat --plain"'
zinit load sharkdp/bat

# fd - Corrected pick pattern
zinit ice lucid from"gh-r" as"command" pick"*/fd"
zinit load sharkdp/fd

# delta - Re-introduced with mv and pick
zinit ice lucid from"gh-r" as"command" mv"delta-* -> delta" pick"*/delta"
zinit load dandavison/delta

# --- End Programs ---

# configure rbenv
eval "$(rbenv init - zsh)"

# General Exports and Custom Scripts
export XDG_CONFIG_HOME="$HOME/.config"
# load custom scripts
if [[ -d ~/.config/zsh/scripts ]]; then
  for FILE in ~/.config/zsh/scripts/*; do
    [[ -f "$FILE" ]] && source "$FILE"
  done
fi

# Ensure compinit is loaded if Zinit's `zicompinit` isn't sufficient or runs too early
# autoload -Uz compinit && compinit -i
