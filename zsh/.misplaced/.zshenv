function load_env_file() {
    local mandatory=false

    if [[ "$1" == "-m" || "$1" == "--mandatory" ]]; then
        mandatory=true
        shift
    fi

    local file="$1" line

    if [[ -f "$file" ]]; then
        while read -r line; do
            [[ -z "$line" || "$line" == '#'* ]] && continue

            local key="${line%% *}"
            local raw_val="${line#* }"

            # The (e) flag forces Zsh to expand variables like $HOME inside the text
            export "$key"="${(e)raw_val}"
        done < "$file"
    elif [[ "$mandatory" == true ]]; then
        print -u2 "${(%):-%F{red}}Error: Mandatory env file missing -> $file%f"
    fi
}

load_env_file -m ~/.config/shell/default.env
load_env_file ~/.config/shell/local.env

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
