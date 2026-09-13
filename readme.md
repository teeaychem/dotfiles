# dotfiles

mise applys configurations to `$HOME` and loads the shared / platform-specific environments.

```sh
mise trust mise/config.toml
mise bootstrap dotfiles status
mise bootstrap dotfiles apply --dry-run

# One line apply
mise trust mise/config.toml && mise bootstrap dotfiles apply
```

```sh
mise --env personal bootstrap dotfiles apply # `--env personal` selects the opt-in personal overlay
```

## fish

```sh
fish_plugins_sync
```

```sh
ssh -t HOST '/home/linuxbrew/.linuxbrew/bin/fish -l'
```

## packages

```sh
brew bundle --file ~/dotfiles/brew/Brewfile.core

# brew bundle --file ~/dotfiles/brew/Brewfile
```

```sh
~/dotfiles/linux/.local/bin/install-apt-packages ~/dotfiles/shared/.config/apt/packages

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## mise

Deployment is idempotent and uses individual symlinks, so a managed directory can also contain machine-local files.

Untracked values go in the highest-priority layer: `~/.config/mise/config.local.toml`


## debugging tools

The package lists provide GDB and an LLVM LLDB adapter.
`~/.local/bin/lldb-dap` resolves Homebrew's keg-only LLVM installation and Ubuntu's versioned adapter names.

Pet uses the Python interpreter selected for the project, so install debugpy in that environment.
For a uv project:

```sh
uv add --dev debugpy
```
