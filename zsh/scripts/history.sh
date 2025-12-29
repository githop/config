# Use a large but safe history size
MAX_SIZE=1000000000
export HISTFILE=~/.config/zsh/.zsh_history
export HISTSIZE=$MAX_SIZE
export SAVEHIST=$MAX_SIZE

# Zsh options
setopt SHARE_HISTORY          # Share history between sessions
setopt EXTENDED_HISTORY       # Write timestamps to the history file
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks before recording entry
setopt HIST_IGNORE_SPACE       # Don't record an entry starting with a space
setopt HIST_VERIFY             # Don't execute immediately upon history expansion
