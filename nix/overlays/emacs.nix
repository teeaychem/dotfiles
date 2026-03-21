# https://wiki.nixos.org/wiki/Emacs

# https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/emacs/default.nix
# - https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/emacs/make-emacs.nix

# https://github.com/nix-community/emacs-overlay/blob/master/overlays/emacs.nix

# https://github.com/d12frosted/homebrew-emacs-plus

self: super: rec {
  emacs-derived = super.emacs-unstable.override {
    withNativeCompilation = true;
    withTreeSitter = true;
    withImageMagick = true;
  };
  emacs-derived-plus =
    if super.stdenv.isDarwin then
      emacs-derived.overrideAttrs (old: {
        patches = [
          (super.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/refs/heads/master/patches/emacs-28/fix-window-role.patch";
            hash = "sha256-+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
          })
          (super.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/round-undecorated-frame.patch";
            hash = "sha256-uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
          })
          (super.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/refs/heads/master/patches/emacs-30/system-appearance.patch";
            hash = "sha256-3QLq91AQ6E921/W9nfDjdOUWR8YVsqBAT/W9c1woqAw=";
          })
        ];
      })
    else
      emacs-derived;
}
