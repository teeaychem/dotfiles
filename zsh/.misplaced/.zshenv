# XDG
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_CACHE_HOME:-$HOME/.state}

export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}

# ZSH
export HISTFILE="$ZDOTDIR/.zhistory" # History filepath
export HISTSIZE=10000                # Maximum events for internal history
export SAVEHIST=10000                # Maximum events in history file

typeset -gU path fpath # ensure path arrays do not contain duplicates.

export REPOS_DIR="${HOME}/repos/"
export LLVM_SRC="${HOME}/repos/llvm/"

# Languages, etc.

# # keras
export KERAS_HOME="${XDG_DATA_HOME}/keras"

# # lean
export ELAN_HOME="${XDG_DATA_HOME}/elan"

# # npm / node
# export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
# path_add "${HOME}/.npm-packages/bin" prepend

# # OCaml
# export OPAMROOT="${XDG_DATA_HOME}/opam"

# # python

export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python_cache"
export PYTHON_HISTORY="${XDG_CACHE_HOME}/python/history"
export IPYTHONDIR="${XDG_CACHE_HOME}/ipython"
export MPLCONFIGDIR="${XDG_CACHE_HOME}/matplotlib"

# Utils

# # docker
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"

# # gpg

# https://www.gnupg.org/(it)/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
export GPG_TTY=$(tty)

# # hunspell
export DICTIONARY="en_GB"
export DICPATH="${XDG_CONFIG_HOME}/hunspell/dictionaries"

# # less
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"
