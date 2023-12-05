
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit ice from"gh-r" as"command" atload'eval "$(starship init zsh)"'
zinit load starship/starship

setopt promptsubst

# Oh my zshell git plugin
zinit lucid for \
        OMZL::git.zsh \
  atload"unalias grv" \
        OMZP::git \
        https://github.com/junegunn/fzf/raw/master/shell/{'completion','key-bindings'}.zsh \
        https://github.com/junegunn/fzf-git.sh/blob/main/fzf-git.sh \
  as"program" \
        https://github.com/junegunn/fzf/blob/master/bin/fzf-tmux


# zsh syntax highlighting, suggestions, completions
zinit wait lucid for \
  atinit"zicompinit; zicdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

# programs
zinit lucid from"gh-r" as"command" for \
    atload'
        eval "$(zoxide init --cmd j zsh)"
    ' pick'zoxide/zoxide' \
        @ajeetdsouza/zoxide \
    mv'ripgrep* -> rg' pick'rg/rg' \
        @BurntSushi/ripgrep \
    mv'bat* -> bat' pick'bat/bat' atload'
        export MANPAGER="bat --plain"
    ' \
        @sharkdp/bat \
        @junegunn/fzf \
    mv'**/delta -> delta' \
        @dandavison/delta

# configure rbenv 
    eval "$(rbenv init - zsh)"

# load custom scripts
for FILE in ~/.config/zsh/scripts/*; do
    source $FILE
done
