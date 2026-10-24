# Home Manager

Run from the checkout root with Nix installed. The managed `nix/nix.conf`
enables `nix-command` and `flakes`. Until it is linked, bootstrap with:

```sh
nix --extra-experimental-features 'nix-command flakes' run .#home-manager -- switch --flake .#portable --impure
```

Use `.#mbp` instead of `.#portable` to bootstrap the personal configuration.

Select the configuration explicitly:

```sh
# Build without changing home links.
nix run .#home-manager -- build --flake .#portable --impure
nix run .#home-manager -- build --flake .#mbp --impure

# Apply the selected configuration.
nix run .#home-manager -- switch --flake .#portable --impure
nix run .#home-manager -- switch --flake .#mbp --impure
```

Both configurations read `$USER`, `$HOME`, and `$PWD` for the user and checkout.
The `portable` configuration uses the running system, excludes
`personal/`, and needs no public machine entry. The named `mbp` configuration
fixes the system to `aarch64-darwin` and adds `personal.nix`.

## Local Nix settings

Home Manager manages `~/.config/nix/nix.conf`.
Optional machine-specific settings/overrides are supported via `nix.conf` containing `!include nix.local.conf` last.
So, machine-specific may be written to `~/.config/nix/nix.local.conf`.

## Linking

Existing file edits apply immediately.
Run `switch` again after Nix or ignore-rule changes, or adding or removing managed files.
Filewise discovery reads the live checkout, so new files need no `git add`.

## Configuration

- `flake.nix`: inputs, configuration composition, and the Home Manager app.
- `home.nix`: shared config lists, platform selection, and link declarations.
- `link-sources.nix`: shared editable-link declarations for source mappings.
- `personal.nix`: personal source mapping, included by the `mbp` configuration.
- `dotfiles.checkout`: source checkout; defaults to `~/dotfiles` when imported.
- `homeModules.default`: exported Home Manager module; consumers supply `home.stateVersion`.

The `mkHome` constructor in `flake.nix` defaults `stateVersion` to `26.05`;
configurations can override it when needed. Keep this compatibility baseline
when updating inputs; change it only after reviewing the relevant Home Manager
migration notes.
