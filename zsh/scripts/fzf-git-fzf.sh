# Redefine this function to change the options
_fzf_git_fzf() {
  fzf-tmux -p80%,60% -- \
    --border-label-pos=2 \
    --color='header:italic:underline,label:blue' \
    --preview 'bat -n --color=always {}' \
    --preview-window='right,66%,border-left' \
    --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"
}
