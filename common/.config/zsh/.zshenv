export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

mkdir -p \
    "$XDG_CONFIG_HOME" \
    "$XDG_CACHE_HOME" \
    "$XDG_DATA_HOME" \
    "$XDG_STATE_HOME"

export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"
mkdir -p "$ZDOTDIR"

load_vars() {
  setopt local_options extended_glob

  local vars_file="$1"

  if [[ ! -f "$vars_file" ]]; then
    echo "Error: Variables file '$vars_file' does not exist or was not specified." >&2
    return 1
  fi

  local line name
  while IFS= read -r line || [[ -n "$line" ]]; do
    name="${line##[[:space:]]#}"
    name="${name%%[[:space:]]#}"
    [[ "$name" == \#* || -z "$name" ]] && continue

    if [[ ! "$name" =~ '^[A-Za-z_][A-Za-z0-9_]*$' ]]; then
      echo "Warning: Ignoring malformed line in '$vars_file': $line" >&2
      continue
    fi

    (( ${+parameters[$name]} )) || typeset -g "$name="
  done < "$vars_file"
}

load_vars "$XDG_CONFIG_HOME/shell/vars/base.vars"

# ZSH
export HISTFILE="$ZDOTDIR/.zhistory" # History filepath
export HISTSIZE=10000                # Maximum events for internal history
export SAVEHIST=10000                # Maximum events in history file

# Languages, etc.



# # npm / node
# export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"

# # OCaml
# export OPAMROOT="${XDG_DATA_HOME}/opam"

# # python

typeset -gU path fpath # ensure path arrays do not contain duplicates.

case "$OSTYPE" in
    darwin*)
        [[ -r "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/modules/init/zsh" ]] &&
            source "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/modules/init/zsh"
        ;;
    linux*)
        [[ -r /usr/share/modules/init/zsh ]] &&
            source /usr/share/modules/init/zsh
        ;;
esac

if (( $+functions[module] )); then
    module use "$XDG_CONFIG_HOME/modules/modulefiles"
    module load dotfiles/base

    case "$OSTYPE" in
        darwin*) module load dotfiles/darwin ;;
        linux*) module load dotfiles/linux ;;
    esac

    if module is-avail dotfiles/local >/dev/null 2>&1; then
        module load dotfiles/local
    fi
fi

# # gpg

# https://www.gnupg.org/(it)/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
export GPG_TTY=$(tty)
