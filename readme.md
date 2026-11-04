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

Scripts from `scripts/common/` and any scripts in `scripts/<platform>/` are installed into `~/.local/bin/`.

## packages

```sh
brew bundle --file ~/dotfiles/brew/Brewfile.core

# brew bundle --file ~/dotfiles/brew/Brewfile
```

```sh
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
