if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zmodload zsh/zprof
fi

source "$HOME/source/0-functions.sh"
source_home sh
source_home zsh
[[ -f "$HOME/repos/fzf-git/fzf-git.sh" ]] && source "$HOME/repos/fzf-git/fzf-git.sh"
source <(jj util completion zsh)

if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zprof
fi
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
