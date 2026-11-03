# dotfiles

## Nix / Home Manager

From the checkout root, with Nix and its `nix-command` and `flakes` features enabled:

```sh
nix run .#home-manager -- build --flake .#portable --impure
nix run .#home-manager -- switch --flake .#portable --impure
nix run .#home-manager -- switch --flake .#mbp --impure
```

Config files remain editable in the checkout. See [the Home Manager notes](nix/README.md)
for linking behavior and configuration options.

## fish

```sh
fish_plugins_sync
```

```sh
ssh -t HOST '/home/linuxbrew/.linuxbrew/bin/fish -l'
```

## scripts

`scripts/common/` and the current platform's `scripts/darwin/` or `scripts/linux/`
are installed together in `~/.local/bin/` by Home Manager.

## packages

```sh
brew bundle --file ~/dotfiles/brew/Brewfile.core

# brew bundle --file ~/dotfiles/brew/Brewfile
```

```sh
~/dotfiles/scripts/linux/install-apt-packages /path/to/packages

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## debugging tools

The package lists provide GDB and an LLVM LLDB adapter.
`~/.local/bin/lldb-dap` resolves Homebrew's keg-only LLVM installation and Ubuntu's versioned adapter names.

Pet uses the Python interpreter selected for the project, so install debugpy in that environment.
For a uv project:

```sh
uv add --dev debugpy
```
