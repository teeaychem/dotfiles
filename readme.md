# dotfiles

GNU Stow deploys these packages into `$HOME`:

- `common`: configuration shared by all systems
- `scripts`: shared commands installed in `~/.local/bin`
- `darwin`: macOS configuration and commands
- `linux`: Linux configuration

Each package contains `.stow-local-ignore` so Git preserves it even when the
package otherwise becomes empty.

## Install

Install Git and GNU Stow, then clone and apply the configuration:

```sh
git clone ssh://git@codeberg.org/teeaychem/dot.git ~/dotfiles
cd ~/dotfiles
./install
```

Preview changes without creating links:

```sh
./install --simulate --verbose
```

The installer uses `--no-folding`, allowing machine-local files to coexist
with links managed by Stow.

On Ubuntu, install the environment-management packages with:

```sh
./linux/.local/bin/install-ubuntu-packages ubuntu-packages
```

After applying the dotfiles, the command is available as
`install-ubuntu-packages PACKAGE_FILE`. The environment-management packages
are listed separately in `ubuntu-packages`.

## Machine-local files

Files such as the following should remain machine-local:

```text
~/.config/git/config.local
~/.config/ghostty/config.local
~/.config/modules/modulefiles/dotfiles/local
~/.config/navidrome.toml
```

The shared Git configuration requires `config.local` to define the user
identity:

```ini
[user]
	name = Your Name
	email = you@example.com
```

## Update

Existing links follow repository updates immediately. Run the installer after
files are added, removed, or moved:

```sh
cd ~/dotfiles
git pull
./install
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
