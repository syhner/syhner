if [[ "$OSTYPE" == "darwin"* ]]; then
  export DOTFILES
  DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
  alias brewdump="brew bundle dump --describe --force --file=\"$DOTFILES/home/(mac)/Brewfile\""
fi
