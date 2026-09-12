# dotfiles

## Install packages

```sh
brew bundle --file ~/dotfiles/brew/Brewfile.core

# brew bundle --file ~/dotfiles/brew/Brewfile
```

```sh
~/dotfiles/linux/.local/bin/install-apt-packages ~/dotfiles/shared/.config/apt/packages

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

## Deploy configuration with Mise

Mise deploys configuration into `$HOME` and loads the shared and platform-specific environment.

```sh
mise trust ~/dotfiles/mise.toml
mise --cd ~/dotfiles bootstrap dotfiles apply
```

```sh
mise --cd ~/dotfiles --env personal bootstrap dotfiles apply
```

Deployment is idempotent and uses individual symlinks, so a managed directory can also contain machine-local files.
Check the result or preview a change with:

```sh
mise --cd ~/dotfiles bootstrap dotfiles status
mise --cd ~/dotfiles bootstrap --only dotfiles --dry-run
```

## Use the environment

Mise auto loads `mise.toml` and then `mise.macos.toml` or `mise.linux.toml`.

`--env personal` selects the opt-in personal overlay and composes with the deployment commands above.

Keep machine-specific values in the untracked, highest-priority layer:

```text
~/.config/mise/config.local.toml
```

Other local configuration can coexist beside managed files:

```text
~/.config/git/config.local
~/.config/ghostty/config.local
```

## Use debugging tools

The package lists provide GDB and an LLVM LLDB adapter.
`~/.local/bin/lldb-dap` resolves Homebrew's keg-only LLVM installation and Ubuntu's versioned adapter names.

Pet uses the Python interpreter selected for the project, so install debugpy in that environment.
For a uv project:

```sh
uv add --dev debugpy
```

Synchronise Fish plugins when their declared set changes:

```sh
fish_plugins_sync
```

To use the configured Fish directly over SSH without changing the remote login shell:

```sh
ssh -t HOST '/home/linuxbrew/.linuxbrew/bin/fish -l'
```
