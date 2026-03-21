# antidote
# # https://getantidote.github.io/usage

if [[ ! -d ${ZDOTDIR:-$HOME}/.antidote ]]; then
        git clone https://github.com/mattmc3/antidote ${ZDOTDIR:-$HOME}/.antidote
fi

source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh
antidote load

# fns

# Change working directory to the top finder window location
function cdf() {
        cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}

# de-quarantine $1
function dq {
        eval "xattr -r -d com.apple.quarantine $1"
}

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

function rmdsstore {
        find "${@:-.}" -type f -name .DS_Store -delete
}

# options

export EDITOR=nvim

# # misc

# # history

setopt HIST_IGNORE_SPACE
HISTORY_IGNORE="(ls|cd|pwd|which|z)*"

# # # no duplication
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FCNTL_LOCK

setopt EXTENDED_HISTORY # additional info

# # # corrections
# setopt CORRECT
# setopt CORRECT_ALL

# # # keys

set -o emacs

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
autoload select-word-style
select-word-style normal

bindkey '^I' complete-word        # tab          | complete
bindkey '^[[Z' autosuggest-accept # shift + tab  | autosuggest

bindkey "\e\e[D" backward-word  # | option + <-
bindkey "^[[1;5D" backward-word # | ctl + <-
bindkey "\e\e[C" forward-word   # | option + ->
bindkey "^[[1;5C" forward-word  # | ctl + ->

# # # completions

zstyle ":completion:*:commands" rehash 1 # no caching

setopt always_to_end    # Move cursor to the end of a completed word.
setopt auto_list        # Automatically list choices on ambiguous completion.
setopt auto_menu        # Show completion menu on a successive tab press.
setopt auto_param_slash # If completed parameter is a directory, add a trailing slash.
setopt complete_in_word # Complete from both ends of a word.
setopt path_dirs        # Perform path search even on command names with slashes.
setopt NO_flow_control  # Disable start/stop characters in shell editor.
setopt NO_menu_complete # Do not autoselect the first completion entry.

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
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
path_add "${HOME}/.npm-packages/bin" prepend

# # OCaml
export OPAMROOT="${XDG_DATA_HOME}/opam"

# # python
alias py="python3"
alias py3="python3"

export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python_cache"
export PYTHON_HISTORY="${XDG_CACHE_HOME}/python/history"
export IPYTHONDIR="${XDG_CACHE_HOME}/ipython"
export MPLCONFIGDIR="${XDG_CACHE_HOME}/matplotlib"

alias pyfind='find . -name "*.py"'
alias pygrep='grep -nr --include="*.py"'

function pyclean {
        find "${@:-.}" -type f -name "*.py[co]" -delete
        find "${@:-.}" -type d -name "__pycache__" -delete
        find "${@:-.}" -depth -type d -name ".mypy_cache" -exec rm -r "{}" +
        find "${@:-.}" -depth -type d -name ".pytest_cache" -exec rm -r "{}" +
}

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

# # grep
alias grep='grep --color=auto'

# # hunspell
export DICTIONARY="en_GB"
export DICPATH="${XDG_CONFIG_HOME}/hunspell/dictionaries"

# # less
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"

# # man
export MANPAGER="nvim +Man!"

# Extensions

eval "$(starship init zsh)"

eval "$(direnv hook zsh)"

FZF_CTRL_T_COMMAND=
if source <(fzf --zsh); then
        # preview
        function fzfp {
                fzf --layout='default' \
                        --ansi \
                        --preview-window=top,75%,sharp,wrap \
                        --bind 'focus:transform-header:file --brief {}' \
                        --bind='ctrl-d:abort' \
                        --bind='ctrl-s:change-preview(stat {})' \
                        --bind='ctrl-e:change-preview(bat -n --color=always {})' \
                        --bind='ctrl-w:toggle-preview'
        }
fi

eval "$(zoxide init bash)"

# closing
autoload -Uz compinit
