# https://wiki.archlinux.org/title/XDG_Base_Directory
# https://specifications.freedesktop.org/basedir-spec/latest/

set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CACHE_HOME $HOME/.cache

set -q HOMEBREW_PREFIX; or switch (uname)
    case Darwin
        set -gx HOMEBREW_PREFIX /opt/homebrew
    case Linux
        set -gx HOMEBREW_PREFIX /home/linuxbrew/.linuxbrew
end

if test -x "$HOMEBREW_PREFIX/bin/brew"
    "$HOMEBREW_PREFIX/bin/brew" shellenv fish | source
end

# Nix initializes its profile paths independently of Homebrew.
if test -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
else if test -r "$XDG_STATE_HOME/nix/profile/etc/profile.d/nix.fish"
    source "$XDG_STATE_HOME/nix/profile/etc/profile.d/nix.fish"
else if test -r "$HOME/.nix-profile/etc/profile.d/nix.fish"
    source "$HOME/.nix-profile/etc/profile.d/nix.fish"
end

# Nix may have initialized before brew shellenv, or in a parent shell.
# Restore profile precedence even when its initialization guard skips setup.
for nix_profile in (string split --no-empty ' ' -- "$NIX_PROFILES")
    fish_add_path --prepend --move --path "$nix_profile/bin"
end

# Search active profiles from highest priority, then standard user-profile locations.
for nix_profile in (string split --no-empty ' ' -- "$NIX_PROFILES")[-1..1] "$XDG_STATE_HOME/nix/profile" "$HOME/.nix-profile"
    if test -r "$nix_profile/etc/profile.d/hm-session-vars.fish"
        source "$nix_profile/etc/profile.d/hm-session-vars.fish"
        break
    end
end
set -e nix_profile

# GnuPG terminal prompts.
if status is-interactive; and test -t 0
    set -gx GPG_TTY (tty)
end

# Load shared shell settings.
load_vars "$XDG_CONFIG_HOME/shell/vars/base.vars"

source "$__fish_config_dir/aliases.fish"

# History filtering and the patterns it uses stay together.
if test -f "$XDG_CONFIG_HOME/shell/history/ignore"
    set -g history_ignore_patterns
    while read -l line
        string match -q -r '^\s*(#|$)' -- "$line"; and continue
        set -a history_ignore_patterns "$line"
    end <"$XDG_CONFIG_HOME/shell/history/ignore"
else
    echo "Error: History ignore file '$XDG_CONFIG_HOME/shell/history/ignore' does not exist." >&2
end

function fish_should_add_to_history
    string match -qr '^\s' -- "$argv[1]"; and return 1

    for pattern in $history_ignore_patterns
        string match -qr -- "$pattern" "$argv[1]"; and return 1
    end

    return 0
end

switch (uname)
    case Darwin
        test -f $__fish_config_dir/darwin.fish; and source $__fish_config_dir/darwin.fish
    case Linux
        test -f $__fish_config_dir/linux.fish; and source $__fish_config_dir/linux.fish
    case '*'
        echo "No configuration for: "(uname)
end

test -f $__fish_config_dir/local.fish; and source $__fish_config_dir/local.fish

# OCaml
# This adds: the correct directories to the PATH, auto-completion for the opam binary
test -r "$OPAMROOT/opam-init/init.fish" && source "$OPAMROOT/opam-init/init.fish" >/dev/null 2>/dev/null; or true

# etc

## https://fishshell.com/docs/current/faq.html#faq-history
function last_history_item
    echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item

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
    bind ctrl-delete kill-path-component
    bind shift-tab accept-autosuggestion
    bind ctrl-left backward-word
    bind ctrl-right forward-word
    bind alt-b backward-word
    bind alt-f forward-word
end

if status is-interactive; and command -q zoxide
    zoxide init fish | source
end

if status is-interactive; and command -q direnv
    direnv hook fish | source
end
