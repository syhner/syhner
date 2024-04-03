if [[ "$OSTYPE" == "darwin"* ]]; then
  # Don't quarantine casks installed with Homebrew
  export HOMEBREW_CASK_OPTS="--no-quarantine"
fi
