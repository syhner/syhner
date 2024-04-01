if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zmodload zsh/zprof
fi

function source_or_install() {
  if [[ "$#" -ne 2 ]]; then
    echo "Usage: source_or_install <source_path> <install_command>"
    exit 1
  fi

  local source_path="$1"
  local install_command="$2"

  if [[ -f "$source_path" ]]; then
    source "$source_path"
  else
    eval "$install_command"
    # assumes that the install command creat
  fi

  if [[ -f "$source_path" ]]; then
    source "$source_path"
  else
    echo "Installation failed to create a file to source at $source_path"
    exit 1
  fi
}

autoload -Uz compinit
compinit

source "$HOME/zsh/powerlevel10k.zsh"
source "$HOME/zsh/git.zsh"

if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zprof
fi
