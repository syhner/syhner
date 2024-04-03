# Completions
if [[ $(current_shell) == "bash" ]]; then
  [ -f ~/.fzf.bash ] && source ~/.fzf.bash
elif [[ $(current_shell) == "zsh" ]]; then
  eval "$(fnm completions --shell zsh)"
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi
