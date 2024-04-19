# Completions
if [[ $(current_shell) == "bash" ]]; then
  if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
    source_if_exists "$HOME/.fzf.bash"
  elif command -v fzf &>/dev/null; then
    eval "$(fzf --bash)"
  fi
elif [[ $(current_shell) == "zsh" ]]; then
  if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
    source_if_exists "$HOME/.fzf.zsh"
  elif command -v fzf &>/dev/null; then
    eval "$(fzf --zsh)"
  fi
fi

if ! command -v fzf &>/dev/null; then
  return
fi

alias fman="compgen -c | fzf | xargs man"

function aliases() {
  eval "$(alias | fzf | awk -F '=' '{print $1}' | cut -d ' ' -f2)"
}
alias a="aliases"

if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_ALT_C_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git --type d"

  _fzf_compgen_path() {
    fd --hideden --exclude .git . "$1"
  }

  _fzf_compgen_dir() {
    fd --hidden --exclude .git --type=d . "$1"
  }
fi

if command -v eza &>/dev/null && command -v bat &>/dev/null && command -v dig &>/dev/null; then
  _fzf_comprun() {
    local command="$1"
    shift

    case "$command" in
    cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export | unset) fzf --preview "eval 'echo \${}'" "$@" ;;
    ssh) fzf --preview 'dig {}' "$@" ;;
    *) fzf --preview "--preview 'bat -n --color=always --line-range :500 {}'" "$@" ;;
    esac
  }
fi

if command -v bat &>/dev/null; then
  export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
fi

if command -v eza &>/dev/null; then
  export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head 200'"
fi
