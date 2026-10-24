# Home Manager

Run from the checkout root with Nix installed.
The managed `nix/nix.conf` enables `nix-command` and `flakes`.
Until it is linked, bootstrap with:

```sh
nix --extra-experimental-features 'nix-command flakes' run .#home-manager -- switch --flake .#portable --impure
```

Select the configuration explicitly:

```sh
# Build without changing home links.
nix run .#home-manager -- build --flake .#portable --impure

# Apply the selected configuration.
nix run .#home-manager -- switch --flake .#portable --impure
```

Use `.#mbp` instead of `.#portable` to bootstrap the mbp configuration.

Configurations read `$USER`, `$HOME`, and `$PWD` for the user and checkout.

## Local Nix settings

Home Manager manages `~/.config/nix/nix.conf`.
Optional machine-specific settings/overrides are supported via `nix.conf` containing `!include nix.local.conf` last.
So, machine-specific may be written to `~/.config/nix/nix.local.conf`.

## Linking

Existing file edits apply immediately.
Run `switch` again after Nix or ignore-rule changes, or adding or removing managed files.
Filewise discovery reads the live checkout, so new files need no `git add`.


## TODO

https://github.com/outfoxxed/impurity.nix
