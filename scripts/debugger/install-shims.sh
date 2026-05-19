#!/usr/bin/env sh
set -eu

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

mkdir -p "$HOME/.cache/gdb"

install_link() {
  target="$1"
  source="$2"

  if [ -e "$target" ]; then
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
      return 0
    fi

    printf '%s\n' "Refusing to overwrite existing file: $target" >&2
    return 1
  fi

  ln -s "$source" "$target"
}

install_link "$HOME/.gdbearlyinit" "$config_home/gdb/gdbearlyinit"
install_link "$HOME/.gdbinit" "$config_home/gdb/gdbinit"
install_link "$HOME/.lldbinit" "$config_home/lldb/init"
