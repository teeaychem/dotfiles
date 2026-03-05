
# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.share
export XDG_STATE_HOME=$HOME/.state


# ZSH
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file
