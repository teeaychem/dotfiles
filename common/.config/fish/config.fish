# https://wiki.archlinux.org/title/XDG_Base_Directory
# https://specifications.freedesktop.org/basedir-spec/latest/

function load_vars
    set -l vars_file $argv[1]

    if not test -f "$vars_file"
        echo "Error: Variables file '$vars_file' does not exist or was not specified." >&2
        return 1
    end

    while read -l line
        set -l name (string trim -- "$line")
        string match -q -r '^(#|$)' -- "$name"; and continue

        if not string match -q -r '^[A-Za-z_][A-Za-z0-9_]*$' -- "$name"
            echo "Warning: Ignoring malformed line in '$vars_file': $line" >&2
            continue
        end

        set -q $name; or set -g $name ''
    end < "$vars_file"
end

function load_aliases
    set -l aliases_file $argv[1]

    if not test -f "$aliases_file"
        echo "Error: Aliases file '$aliases_file' does not exist or was not specified." >&2
        return 1
    end

    while read -l line
        string match -q -r '^\s*(#|$)' -- "$line"; and continue

        if not string match -q '*=*' -- "$line"
            echo "Warning: Ignoring malformed line in '$aliases_file': $line" >&2
            continue
        end

        set -l parts (string split -m 1 '=' -- "$line")
        set -l name (string trim -- "$parts[1]")
        set -l expansion (string trim -- "$parts[2]")
        set -l first (string sub -s 1 -l 1 -- "$expansion")
        set -l last (string sub -s -1 -l 1 -- "$expansion")

        if test "$first" = "$last"; and contains -- "$first" "'" '"'
            set expansion (string sub -s 2 -l (math (string length -- "$expansion") - 2) -- "$expansion")
        end

        if not string match -q -r '^[A-Za-z0-9_.-]+$' -- "$name"
            echo "Warning: Ignoring invalid alias name in '$aliases_file': $name" >&2
            continue
        end

        abbr --add "$name" -- "$expansion"
    end < "$aliases_file"
end

function load_history_ignore
    set -l ignore_file $argv[1]

    if not test -f "$ignore_file"
        echo "Error: History ignore file '$ignore_file' does not exist or was not specified." >&2
        return 1
    end

    set -g history_ignore_patterns

    while read -l line
        string match -q -r '^\s*(#|$)' -- "$line"; and continue
        set -a history_ignore_patterns "$line"
    end < "$ignore_file"
end

set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CACHE_HOME $HOME/.cache


# Usage inside config.fish:
load_vars "$XDG_CONFIG_HOME/shell/vars/base.vars"

load_aliases "$XDG_CONFIG_HOME/shell/aliases/base.aliases"
load_history_ignore "$XDG_CONFIG_HOME/shell/history/ignore"

switch (uname)
    case Darwin
        test -f $__fish_config_dir/darwin.fish; and source $__fish_config_dir/darwin.fish
    case Linux
        test -f $__fish_config_dir/linux.fish; and source $__fish_config_dir/linux.fish
    case '*'
        echo "No configuration for: "(uname)
end

switch (uname)
    case Darwin
        if test -r "$HOMEBREW_PREFIX/opt/modules/init/fish"
            source "$HOMEBREW_PREFIX/opt/modules/init/fish"
            test -r "$HOMEBREW_PREFIX/opt/modules/init/fish_completion"; and source "$HOMEBREW_PREFIX/opt/modules/init/fish_completion"
        end
    case Linux
        test -r /usr/share/modules/init/fish; and source /usr/share/modules/init/fish
        test -r /usr/share/modules/init/fish_completion; and source /usr/share/modules/init/fish_completion
end

if type -q module
    module use "$XDG_CONFIG_HOME/modules/modulefiles"
    module load dotfiles/base

    switch (uname)
        case Darwin
            module load dotfiles/darwin
        case Linux
            module load dotfiles/linux
    end

    module is-avail dotfiles/local >/dev/null 2>&1; and module load dotfiles/local
end

# hammerspoon
# defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

# OCaml
# This adds: the correct directories to the PATH, auto-completion for the opam binary
test -r "$OPAMROOT/opam-init/init.fish" && source "$OPAMROOT/opam-init/init.fish" >/dev/null 2>/dev/null; or true

# etc

## https://fishshell.com/docs/current/faq.html#faq-history
function last_history_item
    echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item

function fish_should_add_to_history
    for pattern in $history_ignore_patterns
        string match -qr -- "$pattern" "$argv"; and return 1
    end

    return 0
end

# fzf
if status is-interactive; and command -q fzf
    fzf --fish | source

    if test -f "$XDG_CONFIG_HOME/fzf/default_ops"
        set -x FZF_DEFAULT_OPTS_FILE "$XDG_CONFIG_HOME/fzf/default_ops"
    end

    if command -q tree
        set -gx FZF_ALT_C_OPTS "--preview 'tree -C {} | head -50'"
    end
end

# setup

if status is-interactive
    fish_default_key_bindings

    bind ctrl-h backward-kill-word
    bind shift-tab accept-autosuggestion
    bind alt-b backward-word
    bind alt-f forward-word
end

if status is-interactive; and command -q zoxide
    zoxide init fish | source
end

if status is-interactive; and command -q direnv
    direnv hook fish | source
end
