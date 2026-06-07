# https://wiki.archlinux.org/title/XDG_Base_Directory
# https://specifications.freedesktop.org/basedir-spec/latest/

function load_env
    set -l env_file $argv

    # Catches both an empty argument and a missing file path
    if not test -f "$env_file"
        if not string match -q 'local*' (path basename "$env_file")
            echo "Error: Environment file '$env_file' does not exist or was not specified." >&2
        end
        return 1
    end

    while read -l line
        # Skip lines that are empty or start with '#'
        string match -q -r '^\s*(#|$)' $line; and continue

        # Split into key and value around the first '=' sign
        set -l kv (string split -m 1 '=' $line)
        set -l key $kv[1]

        # 1. Trim surrounding single or double quotes
        set -l clean_val (string trim -c '"\'' $kv[2])

        # 2. Expand embedded variables (e.g. $HOME) without evaluating commands
        set -l expanded_val $clean_val
        for variable_ref in (string match -ra '\$[A-Za-z_][A-Za-z0-9_]*' -- "$clean_val")
            set -l variable_name (string sub -s 2 -- $variable_ref)
            if set -q $variable_name
                set expanded_val (string replace -a -- "$variable_ref" "$$variable_name" "$expanded_val")
            else
                echo "Warning: Environment variable '$variable_name' referenced by '$key' is not set." >&2
            end
        end

        # 3. Export the key and the fully expanded value globally
        set -gx $key $expanded_val
    end < $env_file
end

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

set -gx XDG_CONFIG_HOME $HOME/.config/


# Usage inside config.fish:
load_vars "$XDG_CONFIG_HOME/envs/base.vars"
load_env "$XDG_CONFIG_HOME/envs/base.env"
load_env "$XDG_CONFIG_HOME/envs/local.env"

switch (uname)
    case Darwin
        source $__fish_config_dir/darwin.fish
    case Linux
        source $__fish_config_dir/linux.fish
    case '*'
        echo "No configuration for: "(uname)
end

# hammerspoon
# defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

# man
set -x MANPAGER "nvim +Man!"

# editor
set -gx EDITOR nvim

# npm / node
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"

# OCaml
set -gx OPAMROOT "$XDG_DATA_HOME/opam"

# This adds: the correct directories to the PATH, auto-completion for the opam binary
test -r "$OPAMROOT/opam-init/init.fish" && source "$OPAMROOT/opam-init/init.fish" >/dev/null 2>/dev/null; or true

set -gx PATH (string split : ("$XDG_CONFIG_HOME/scripts/common/path"))

# etc

## https://fishshell.com/docs/current/faq.html#faq-history
function last_history_item
    echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item

function fish_should_add_to_history
    # Ignore base commands safely, accounting for symbols like dashes
    if string match -qr "^(man|which|ls|cd|z|pkgconf|pkg-config)(\s|\$)" -- $argv
        return 1
    end

    # Ignore specific cargo subcommands
    if string match -qr "^cargo\s+(init)(\s|\$)" -- $argv
        return 1
    end

    # Ignore specific git subcommands
    if string match -qr "^git\s+(add|commit|pop|remove|rename|restore|rm|stash|status|submodule)(\s|\$)" -- $argv
        return 1
    end

    # Ignore flags (-v, -V, -h, -H, or --help) at the very end of a line
    if string match -qr "\s+-{1,2}(v|V|h|H|help)\$" -- $argv
        return 1
    end

    return 0
end

# tools
set -gx FD_OPTIONS "--hidden --follow"

abbr -a fdd "fd --type d"
abbr -a fdf "fd --type f"
abbr -a fda "fd --no-ignore --hidden"
abbr -a fde "fd --type f --extension"

abbr -a grep "grep --color=auto"
abbr -a ll "ls -lh"

abbr -a py python3
abbr -a python python3
abbr -a pyfind 'find . -name "*.py"'
abbr -a pygrep 'rg -g "*.py" -g "!**/site-packages/"'

function venv-activate
    # Fallback to .venv if no path argument is provided
    set -l venv_root $argv[1]
    test -n "$venv_root"; or set venv_root .venv

    # Strip any trailing slashes
    set venv_root (string replace -r '/$' '' -- "$venv_root")

    if test -f "$venv_root/bin/activate.fish"
        source "$venv_root/bin/activate.fish"
        echo "Activated venv: $venv_root"
    else
        echo "Unable to activate venv: $venv_root" >&2
        return 1
    end
end

# fzf
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'

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
