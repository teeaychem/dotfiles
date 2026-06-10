# # https://getantidote.github.io/usage

if [[ ! -d ${ZDOTDIR:-$HOME}/.antidote ]]; then
    git clone https://github.com/mattmc3/antidote ${ZDOTDIR:-$HOME}/.antidote
fi

source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh
antidote load

fpath=("${XDG_CONFIG_HOME}/zsh/functions" $fpath)
autoload -Uz load_aliases venv-activate

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

load_aliases "$XDG_CONFIG_HOME/shell/aliases/base.aliases"

# options

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

typeset -ga history_ignore_patterns
history_ignore_patterns=()

while IFS= read -r pattern || [[ -n "$pattern" ]]; do
    [[ "$pattern" =~ '^[[:space:]]*(#|$)' ]] && continue
    history_ignore_patterns+=("$pattern")
done < "$XDG_CONFIG_HOME/shell/history/ignore"

function _ignore_history() {
    emulate -L zsh

    local command="${1%%$'\n'}"
    local pattern

    for pattern in "${history_ignore_patterns[@]}"; do
        [[ "$command" =~ "$pattern" ]] && return 1
    done

    return 0
}

autoload -Uz add-zsh-hook
add-zsh-hook zshaddhistory _ignore_history

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

if [[ -o interactive ]] && (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi


# closing
autoload -Uz compinit
