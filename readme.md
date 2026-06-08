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

## Machine-local files

Files such as the following should remain machine-local:

```text
~/.config/git/config.local
~/.config/ghostty/config.local
~/.config/shell/env/local.env
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
