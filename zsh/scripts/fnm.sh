  # fnm
FNM_PATH="/home/githop/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/githop/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi
