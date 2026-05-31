export XDG_CONFIG_HOME="${HOME}/.config"

load_env() {
  if [ ! -f "$1" ]; then
    echo "Error: Environment file '$1' does not exist or was not specified." >&2
    return 1
  fi


  set -a  # auto export all assigned variables

  source <(sed '/^[[:space:]]*#/d; /^[[:space:]]*$/d' "$1") # | tee /dev/tty)

  set +a  # de-auto exporting
}

load_env "$XDG_CONFIG_HOME/shell/default.env"
load_env "$XDG_CONFIG_HOME/shell/local.env"

mkdir -p \
    "$XDG_CONFIG_HOME" \
    "$XDG_CACHE_HOME" \
    "$XDG_DATA_HOME" \
    "$XDG_STATE_HOME"

export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
mkdir -p ${ZDOTDIR}

# ZSH
export HISTFILE="$ZDOTDIR/.zhistory" # History filepath
export HISTSIZE=10000                # Maximum events for internal history
export SAVEHIST=10000                # Maximum events in history file

export REPOS_DIR="${HOME}/repos"
export LLVM_SRC="${HOME}/repos/llvm"

# Languages, etc.



# # npm / node
# export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
# path_add "${HOME}/.npm-packages/bin" prepend

# # OCaml
# export OPAMROOT="${XDG_DATA_HOME}/opam"

# # python

typeset -gU path fpath # ensure path arrays do not contain duplicates.

# # gpg

# https://www.gnupg.org/(it)/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
export GPG_TTY=$(tty)
