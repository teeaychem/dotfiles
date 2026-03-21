# XDG
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_CACHE_HOME:-$HOME/.state}

export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}

# ZSH
export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file

typeset -gU path fpath # ensure path arrays do not contain duplicates.



function path_add {
        element=${1%/}
        if [ -d "$1" ] && ! echo $PATH | grep -E -q "(^|:)$element($|:)"; then
                case "$2" in
                "append")
                        PATH="${PATH:+${PATH}:}$1"
                        ;;
                "prepend")
                        PATH="$1${PATH:+:${PATH}}"
                        ;;
                "")
                        PATH="$1${PATH:+:${PATH}}"
                        ;;
                *)
                        echo -N "Unexpected path_add specification: ${2}"
                        ;;
                esac
        fi
}


# OS earlyish
case "$OSTYPE" in
darwin*)
        eval "$(/opt/homebrew/bin/brew shellenv)"
        # llvm
        # path_add "/opt/homebrew/opt/llvm/bin/" "prepend"
        # export LDFLAGS="-L/opt/homebrew/opt/llvm/lib -L/opt/homebrew/opt/llvm/lib/c++ -L/opt/homebrew/opt/llvm/lib/unwind -lunwind"
        # export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
        # export CMAKE_PREFIX_PATH="/opt/homebrew/opt/llvm"
        path_add "/usr/local/texlive/2026basic/bin/universal-darwin/" "prepend"

        export HOMEBREW_NO_AUTO_UPDATE
        export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/brew/Brewfile"

        [[ -x $(which bat) ]] && export HOMEBREW_BAT=1
        ;;
linux*) ;;
*)
        echo "No configuration for: $OSTYPE"
        ;;
esac


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

# # rust
export CARGO_HOME="${HOME}/.cargo"
if [[ -d $CARGO_HOME ]]; then
        if [[ -f $CARGO_HOME/env && -r $CARGO_HOME/env ]]; then
                source "${CARGO_HOME}/env"
        else
                echo "CARGO_HOME set, but CARGO_HOME/env unavailable"
        fi
fi

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

