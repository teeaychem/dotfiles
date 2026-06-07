# # https://getantidote.github.io/usage

if [[ ! -d ${ZDOTDIR:-$HOME}/.antidote ]]; then
    git clone https://github.com/mattmc3/antidote ${ZDOTDIR:-$HOME}/.antidote
fi

source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh
antidote load

fpath=("${XDG_CONFIG_HOME}/zsh/functions" $fpath)
autoload -Uz venv-activate

# Path configuration, as macOS executes path_helper *after* sourcing zshenv
# https://apple.stackexchange.com/questions/432226/homebrew-path-set-in-zshenv-is-overridden
case "$OSTYPE" in
    darwin*)
    if [[ -f ${XDG_CONFIG_HOME}/zsh/darwin.sh ]]; then
        source ${XDG_CONFIG_HOME}/zsh/darwin.sh
    fi
    ;;
    linux*)
    if [[ -f ${XDG_CONFIG_HOME}/zsh/linux.sh ]]; then
        source ${XDG_CONFIG_HOME}/zsh/linux.sh
    fi
    ;;
    *)
    echo "No configuration for: $OSTYPE"
    ;;
esac

export PATH="$("${XDG_CONFIG_HOME}/scripts/common/path")"

# options

EDITOR=nvim

# # misc

unsetopt CLOBBER
unsetopt NOMATCH

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

local -a history_to_ignore=(
    'clear'
    'date'
    'df'
    'dirs'
    'du'
    'echo'
    'echo(| *)'
    'exit'
    'fc'
    'git (add|commit|log|reset|restore|rm|status)(| *)'
    'help'
    'history'
    'htop'
    'info'
    'll'
    'll'
    'ls(| *)'
    'man(| *)'
    'mkdir'
    'open'
    'pbcopy'
    'pbpaste'
    'popd'
    'ps(| *)'
    'pushd'
    'pwd'
    'rm(| *)'
    'rmdir'
    'time'
    'top'
    'touch(| *)'
    'which(| *)'
)

HISTORY_IGNORE="${(j:|:)history_to_ignore}"

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

# #
export FD_OPTIONS="--hidden --follow"

alias fdd="fd --type d"             # Find directories only
alias fdf="fd --type f"             # Find files only
alias fda="fd --no-ignore --hidden" # Find everything (ignores .gitignore)
alias fde="fd --type f --extension" # Find files by extension (e.g., fde py)

# # grep
alias grep='grep --color=auto'

# # ls
alias ll="ls -lh"

# # man
export MANPAGER="nvim +Man!"

# # python

alias py="python3"
alias python="python3"

alias pyfind='find . -name "*.py"'
alias pygrep='rg -g "*.py" -g "!**/site-packages/"'

# # rust
export CARGO_HOME="${HOME}/.cargo"
if [[ -d $CARGO_HOME ]]; then
    if [[ -f $CARGO_HOME/env && -r $CARGO_HOME/env ]]; then
        source "${CARGO_HOME}/env"
    else
        echo "CARGO_HOME set, but CARGO_HOME/env unavailable"
    fi
fi

# # OCaml
export OPAMROOT="${XDG_DATA_HOME}/opam"
[[ -r "$OPAMROOT/opam-init/init.zsh" ]] && source "$OPAMROOT/opam-init/init.zsh" >/dev/null 2>/dev/null

# extensions

FZF_CTRL_T_COMMAND=
if [[ -o interactive ]] && (( $+commands[fzf] )); then
    source <(fzf --zsh)
fi

if (( $+commands[tree] )); then
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"
fi

if [[ -o interactive ]] && (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
fi


# closing
autoload -Uz compinit
