export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

mkdir -p \
    "$XDG_CONFIG_HOME" \
    "$XDG_CACHE_HOME" \
    "$XDG_DATA_HOME" \
    "$XDG_STATE_HOME"

export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"
mkdir -p "$ZDOTDIR"

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

load_vars() {
  setopt local_options extended_glob

  local vars_file="$1"

  if [[ ! -f "$vars_file" ]]; then
    echo "Error: Variables file '$vars_file' does not exist or was not specified." >&2
    return 1
  fi

  local line name
  while IFS= read -r line || [[ -n "$line" ]]; do
    name="${line##[[:space:]]#}"
    name="${name%%[[:space:]]#}"
    [[ "$name" == \#* || -z "$name" ]] && continue

    if [[ ! "$name" =~ '^[A-Za-z_][A-Za-z0-9_]*$' ]]; then
      echo "Warning: Ignoring malformed line in '$vars_file': $line" >&2
      continue
    fi

    (( ${+parameters[$name]} )) || typeset -g "$name="
  done < "$vars_file"
}

load_vars "$XDG_CONFIG_HOME/shell/vars/base.vars"

# ZSH
export HISTFILE="$ZDOTDIR/.zhistory" # History filepath
export HISTSIZE=10000                # Maximum events for internal history
export SAVEHIST=10000                # Maximum events in history file

typeset -gU path fpath # ensure path arrays do not contain duplicates.

# Search active profiles from highest priority, then standard user-profile locations.
for nix_profile in ${(Oa)${=NIX_PROFILES}} "$XDG_STATE_HOME/nix/profile" "$HOME/.nix-profile"; do
    if [[ -r "$nix_profile/etc/profile.d/hm-session-vars.sh" ]]; then
        source "$nix_profile/etc/profile.d/hm-session-vars.sh"
        break
    fi
done
unset nix_profile
