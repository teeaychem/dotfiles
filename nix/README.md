# Home Manager

Run from the checkout root with Nix and Fish installed:

```sh
./hm-setup build             # Build only.
./hm-setup                   # Apply (switch).
./hm-setup --personal build  # Build with personal/.
./hm-setup --personal        # Apply with personal/.
```

The current system, `$USER`, `$HOME`, and `$PWD` configure the target machine
and checkout.
`--personal` must come first; the default excludes `personal/`.

## Linking

Existing file edits apply immediately.
Rerun setup after Nix or ignore-rule changes, or adding or removing managed files.
Filewise discovery reads the live checkout, so new files need no `git add`.

## Configuration

- `flake.nix`: inputs, profiles, and the `lib.mapDirFilewise` lambda.
- `home.nix`: config lists, platform selection, and link declarations.
- `dotfiles.checkout`: source checkout; defaults to `~/dotfiles` when imported.
- `dotfiles.personal`: opt-in personal layer.
- `homeModules.default`: exported Home Manager module.
