source "$HOME/source/1-powerlevel10k.zsh"
source "$HOME/source/1-zsh-completions.zsh"
source "$HOME/source/1-zsh-you-should-use.zsh"
source "$HOME/source/2-zsh-autosuggestions.zsh"
source "$HOME/source/2-zsh-syntax-highlighting.zsh"
source "$HOME/source/3-zsh-history-substring-search.zsh"

[[ -n $DEBUG_ZSH_STARTUP ]] && zprof

export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
export PATH="$HOME/repos/nom:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/siraj/.lmstudio/bin"
