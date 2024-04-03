# Globs that don't match anything should be silent
shopt -s nullglob

source "$HOME/.shrc"
for dir in "$HOME/source-"*; do
  for file in "$dir/"*.bash; do
    if [[ -f "$file" ]]; then
      source "$file"
    fi
  done
done
