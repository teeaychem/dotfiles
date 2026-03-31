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

function rmdsstore {
    find "${@:-.}" -type f -name .DS_Store -delete
}

# options

export EDITOR=nvim

# # misc

# # history

# # # no duplication
setopt HIST_EXPIRE_DUPS_FIRST # delete duplicates first when size exceeds HISTSIZE
setopt HIST_FCNTL_LOCK        # locking thorugh fcntl
setopt HIST_FIND_NO_DUPS      # do not display duplicates of a line previously found
setopt HIST_IGNORE_ALL_DUPS   # replace older commands with duplicated newer
setopt HIST_IGNORE_DUPS       # ignore duplicated commands
setopt HIST_IGNORE_SPACE      # ignore commands that start with space
setopt HIST_SAVE_NO_DUPS      # older commands that duplicate newer ones are omitted
setopt HIST_VERIFY            # show expansion before running it

# setopt inc_append_history
setopt share_history # hare command history data, append history and read on each call

setopt EXTENDED_HISTORY # record timestamp of command

HISTORY_IGNORE=""

HISTORY_IGNORE_CONFIG="${ZDOTDIR}/history_ignore_config"
if [ -f "${HISTORY_IGNORE_CONFIG}" ]; then
    . "${HISTORY_IGNORE_CONFIG}"
    HISTORY_IGNORE="(${(j:|:)IGNORE_COMMANDS})${HISTORY_IGNORE}"
fi

# to stop history being added in the first place...
# zshaddhistory() {
#     emulate -L zsh
#     [[ $1 != ${~HISTORY_IGNORE} ]]
# }

# # # corrections
# setopt CORRECT
# setopt CORRECT_ALL

# # # keys

set -o emacs

WORDCHARS='*?.&!#%^'
autoload select-word-style
select-word-style normal

bindkey '^H' backward-kill-word   # C-DEL
bindkey '^I' complete-word        # tab          | complete
bindkey '^[[Z' autosuggest-accept # shift + tab  | autosuggest

bindkey "^[b" backward-word     # | option + <-
bindkey "^[[1;5D" backward-word # | ctl + <-
bindkey "^[f" forward-word      # | option + ->
bindkey "^[[1;5C" forward-word  # | ctl + ->

# # # completions

zstyle ":completion:*:commands" rehash 1 # no caching

setopt ALWAYS_TO_END    # move cursor to the end of a completed word
setopt AUTO_LIST        # automatically list choices on ambiguous completion
setopt AUTO_MENU        # show completion menu on a successive tab press
setopt AUTO_PARAM_SLASH # if completed parameter is a directory, add a trailing slash
setopt COMPLETE_IN_WORD # complete from both ends of a word
setopt PATH_DIRS        # perform path search even on command names with slashes
setopt NO_FLOW_CONTROL  # disable start/stop characters in shell editor
setopt NO_MENU_COMPLETE # do not autoselect the first completion entry

# Tools

# # grep
alias grep='grep --color=auto'

# # man
export MANPAGER="nvim +Man!"

# # python

alias py="python3"

alias pyfind='find . -name "*.py"'
# alias pygrep='grep -nr --include="*.py"'
alias pygrep='rg -g "*.py" -g "!**/site-packages/"'

function venv-activate() {
    local venv_root=".venv"
    if [ $1 ]; then
        venv_root=$1
    fi

    if [ -d "${venv_root}" ] && [ -f "${venv_root}/bin/activate" ]; then
        echo "Activated venv: ${venv_root}"
        source "${venv_root}/bin/activate"
    else
        echo "Unable to activate venv: ${venv_root}"
    fi
}

function pyclean {
    find "${@:-.}" -type f -name "*.py[co]" -delete
    find "${@:-.}" -type d -name "__pycache__" -delete
    find "${@:-.}" -depth -type d -name ".mypy_cache" -exec rm -r "{}" +
    find "${@:-.}" -depth -type d -name ".pytest_cache" -exec rm -r "{}" +
}

# Extensions

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

eval "$(zoxide init zsh)"

# alibi
alias ll="ls -lh"

# closing
autoload -Uz compinit
