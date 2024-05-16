# https://zsh.sourceforge.io/Doc/Release/Options.html

# 01 - Changing directories

# 02 - Completion

# 03 - Expansion and Globbing

# 04 - History
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt append_history
setopt share_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt extended_history
setopt hist_no_store
setopt inc_append_history_time

# 05 - Initialisation

# 06 - Input/Output

# 07 - Job Control

# 08 - Prompting

# 09 - Scripts and Functions

# 10 - Shell emulation

# 11 - Shell state
