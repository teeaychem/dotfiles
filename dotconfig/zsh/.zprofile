# Initialize the login environment after macOS /etc/zprofile runs path_helper.
# Non-login shells inherit this environment from their parent.
mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$ZDOTDIR"

case "$OSTYPE" in
    darwin*) export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}" ;;
    linux*)  export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/home/linuxbrew/.linuxbrew}" ;;
esac

if [[ -x "${HOMEBREW_PREFIX:-}/bin/brew" ]]; then
    eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv zsh)"
fi

# Nix initializes its profile paths independently of Homebrew.
if [[ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
elif [[ -r "$XDG_STATE_HOME/nix/profile/etc/profile.d/nix.sh" ]]; then
    source "$XDG_STATE_HOME/nix/profile/etc/profile.d/nix.sh"
elif [[ -r "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# Nix may have initialized before brew shellenv, or in a parent shell.
# Restore profile precedence even when its initialization guard skips setup.
typeset -gU path fpath
for nix_profile in ${=NIX_PROFILES}; do
    [[ -d "$nix_profile/bin" ]] && path=("$nix_profile/bin" $path)
done
unset nix_profile

# Search active profiles from highest priority, then standard user-profile locations.
for nix_profile in ${(Oa)${=NIX_PROFILES}} "$XDG_STATE_HOME/nix/profile" "$HOME/.nix-profile"; do
    if [[ -r "$nix_profile/etc/profile.d/hm-session-vars.sh" ]]; then
        source "$nix_profile/etc/profile.d/hm-session-vars.sh"
        break
    fi
done
unset nix_profile
