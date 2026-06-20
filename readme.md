# dotfiles

GNU Stow deploys these packages into `$HOME`:

- `common`: configuration shared by all systems
- `scripts`: shared commands installed in `~/.local/bin`
- `darwin`: macOS configuration and commands
- `linux`: Linux configuration

Each package contains `.stow-local-ignore` so Git preserves it even when the
package otherwise becomes empty.

## Utils

### Fish

``` sh
fish_plugins_sync
```

## Install

Clone the repository, install the platform package set, then apply the
configuration:

```sh
git clone ssh://git@codeberg.org/teeaychem/dot.git ~/dotfiles
cd ~/dotfiles
```

On macOS, use the core Homebrew bundle:

```sh
brew bundle --file common/.config/brew/Brewfile.core
```

On Ubuntu, use the package list and installer:

```sh
./linux/.local/bin/install-apt-packages common/.config/apt/packages
```

This installs the prerequisites for Homebrew on Linux plus the small set of
packages needed before Homebrew is available. To install Homebrew itself, use
the installer from <https://brew.sh/>. This setup uses a home-local Linuxbrew
prefix at `~/.linuxbrew`, which is appropriate for shared SSH machines.

Then apply the Stow links:

```sh
./install
```

After Homebrew is installed and the dotfiles are linked, start a fresh shell and
install the Homebrew tools:

```sh
brew bundle --file linux/.config/brew/Brewfile
```

For a fresh apt-based SSH host, bootstrap the foundations from an existing
checkout:

```sh
bootstrap-apt-host HOST
```

This reads the apt and core Brew package lists from local installed config,
runs the remote apt bootstrap, installs Homebrew under `~/.linuxbrew`, and
installs the shared core Brew bundle. Reconnect into Brew Fish, then clone or
copy the dotfiles into a persistent checkout and run the normal install:

```sh
ssh -t HOST '~/.linuxbrew/bin/fish -l'
```

After the first install, the wrapper command is available from any directory:

```sh
dotfiles-install
```

Preview changes without creating links:

```sh
dotfiles-install --simulate --verbose
```

The installer uses `--no-folding`, allowing machine-local files to coexist
with links managed by Stow.

After applying the dotfiles, the command is available as
`install-apt-packages PACKAGE_FILE`.

These package lists include Environment Modules (`modules` on Homebrew,
`environment-modules` on Ubuntu), which Fish uses to load the shared, platform,
and machine-local environment modulefiles. The platform modules also set
`HOMEBREW_BUNDLE_FILE`, so after module initialization `brew bundle` uses the
platform Brewfile by default.

For a fuller macOS workstation install, use `darwin/.config/brew/Brewfile`,
which includes the shared core bundle, shared optional bundle, and the macOS
optional bundle. The Linux platform Brewfile includes the shared core and shared
optional bundles.

## Debugging

The Homebrew and Ubuntu package lists install GDB and LLVM's LLDB adapter.
`~/.local/bin/lldb-dap` resolves Homebrew's keg-only LLVM installation and
Ubuntu's versioned adapter names.

Pet runs debugpy with the Python interpreter selected for the current project,
so debugpy must also be present in that environment. For uv projects:

```sh
uv add --dev debugpy
```

## Machine-local files

Files such as the following should remain machine-local:

```text
~/.config/git/config.local
~/.config/ghostty/config.local
~/.config/modules/modulefiles/dotfiles/local
```

## Update

Existing links follow repository updates immediately. Run the installer after
files are added, removed, or moved:

```sh
cd ~/dotfiles
git pull
dotfiles-install
```

## Audit

Generate `config.ignore` from the preserved `.gitignore` patterns:

```sh
dotfiles-config-ignore
```

List files under `$XDG_CONFIG_HOME` that are neither matched by
`config.ignore` nor symlinks managed by this Stow repository:

```sh
dotfiles-config-audit
```

The result is a review list, not an instruction to move every reported file.
It can include current machine-local files whose long-term placement remains
undecided. Update `.gitignore` and regenerate after deciding a path should
remain local or is generated state.

## Environment configuration

Environment Modules provides shared, platform, and machine-local environment
configuration:

```text
~/.config/modules/modulefiles/dotfiles/base
~/.config/modules/modulefiles/dotfiles/darwin
~/.config/modules/modulefiles/dotfiles/linux
~/.config/modules/modulefiles/dotfiles/local
```

Shell startup loads `dotfiles/base`, the current platform module, then the
optional untracked `dotfiles/local` module. This gives machine-local values the
highest priority.

Use `setenv` for baseline scalar values and the path commands for path-like
variables:

```tcl
#%Module

setenv EDITOR nvim
prepend-path PATH /opt/llvm/bin
```

Use `pushenv` in temporary or overriding modules when unloading should restore
the previous value.

`XDG_CONFIG_HOME`, `XDG_STATE_HOME`, `XDG_DATA_HOME`, and `XDG_CACHE_HOME`
remain shell bootstrap variables because they are needed before Modules is
initialized. Known unexported variable names used for completion remain in
`~/.config/shell/vars/base.vars`.
