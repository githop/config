export QWEN_PIPELINE_DIR="/home/githop/qwen-tts-sandbox"
alias v-prep="$QWEN_PIPELINE_DIR/process_voice.py"
alias v-profile="$QWEN_PIPELINE_DIR/create_profile.py"
alias v-gen="$QWEN_PIPELINE_DIR/generate_audio.py"

# 2. Tell Zinit to manage the local completion directory
zinit fpath self "$QWEN_PIPELINE_DIR/.completions"

# 3. Enable alias completion
setopt COMPLETE_ALIASES

# 4. Source completions to ensure they are registered for both aliases and paths
[[ -f "$QWEN_PIPELINE_DIR/.completions/_v-prep" ]] && source "$QWEN_PIPELINE_DIR/.completions/_v-prep"
[[ -f "$QWEN_PIPELINE_DIR/.completions/_v-profile" ]] && source "$QWEN_PIPELINE_DIR/.completions/_v-profile"
[[ -f "$QWEN_PIPELINE_DIR/.completions/_v-gen" ]] && source "$QWEN_PIPELINE_DIR/.completions/_v-gen"
