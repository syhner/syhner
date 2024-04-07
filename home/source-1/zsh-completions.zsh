if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  export FPATH="$HOME/zsh-completions/src:$FPATH"
fi
