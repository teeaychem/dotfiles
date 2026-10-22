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

Links point into the editable checkout.
Most configs use directory links; Emacs, Zsh, and Shell use individual file links via `map-dir-filewise.nix`.
The helper also maps home files and scripts, excluding exclusions.

Existing file edits apply immediately.
Rerun setup after Nix changes or adding or removing individually linked files.
Filewise discovery reads the live checkout, so new files need no `git add`.

## Configuration

- `home.nix`: config lists, platform selection, and link declarations.
- `dotfiles.checkout`: source checkout; defaults to `~/dotfiles` when imported.
- `dotfiles.personal`: opt-in personal layer.
- `homeModules.default`: exported Home Manager module.
