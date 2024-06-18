if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  if ! command -v pyenv &>/dev/null; then
    return
  fi
  eval "$(pyenv init -)"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  if ! command -v pyenv &>/dev/null; then
    return
  fi
  eval "$(pyenv init -)"
elif [[ "$OSTYPE" == "msys" ]]; then
  export PYENV="$HOME/.pyenv/pyenv-win"
  export PYENV_HOME="$HOME/.pyenv/pyenv-win"
  export PYENV_ROOT="$HOME/.pyenv/pyenv-win"
  export PATH="$PYENV_ROOT/bin:$PATH"
  export PATH="$PYENV_ROOT/shims:$PATH"
fi
