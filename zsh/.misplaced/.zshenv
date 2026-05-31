export XDG_CONFIG_HOME="${HOME}/.config"

_expand_env_value() {
  local key="$1"
  local value="$2"
  local remaining="$value"
  local variable_ref variable_name

  while [[ "$remaining" =~ '\$[A-Za-z_][A-Za-z0-9_]*' ]]; do
    variable_ref="$MATCH"
    variable_name="${variable_ref#\$}"

    if (( ${+parameters[$variable_name]} )); then
      value="${value//${variable_ref}/${(P)variable_name}}"
    else
      echo "Warning: Environment variable '$variable_name' referenced by '$key' is not set." >&2
    fi

    remaining="${remaining#*${variable_ref}}"
  done

  REPLY="$value"
}

load_env() {
  local env_file="$1"

  if [[ ! -f "$env_file" ]]; then
    if [[ "${env_file:t}" != local* ]]; then
      echo "Error: Environment file '$env_file' does not exist or was not specified." >&2
    fi
    return 1
  fi

  local line key value
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ '^[[:space:]]*(#|$)' ]] && continue

    if [[ "$line" != *=* ]]; then
      echo "Warning: Ignoring malformed line in '$env_file': $line" >&2
      continue
    fi

    key="${line%%=*}"
    value="${line#*=}"

    if [[ "$value" == \"*\" || "$value" == \'*\' ]]; then
      value="${value[2,-2]}"
    fi

    _expand_env_value "$key" "$value"
    export "$key=$REPLY"
  done < "$env_file"
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
