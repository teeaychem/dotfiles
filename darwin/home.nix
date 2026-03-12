{
  inputs,
  outputs,
  pkgs,
  pkgs-unstable,
  ...
}:

{

  home = {
    stateVersion = "25.11";
    username = "sparkes";
    homeDirectory = "/Users/sparkes";

    file.".config" = {
      source = ../dot-config;
      recursive = true;
    };

    packages = [

      pkgs.emacs-derived-plus
      pkgs.gnugrep
      pkgs.lazygit
      pkgs.qemu

      pkgs.cvc5
      pkgs.z3

      pkgs.python3

      # llvmPackages_21.clang-tools
      pkgs.comrak # GF(Markdown)

      pkgs.prettier

      pkgs.universal-ctags

      pkgs.keka
      pkgs.keepassxc
      pkgs.xld

      # cmake
      pkgs.cmake
      pkgs.gersemi

      # lua
      pkgs.luajitPackages.luarocks

      # nix
      pkgs.nil

      # python
      pkgs.ruff
      pkgs-unstable.ty
      pkgs.uv

      # rust
      # pkgs.rust-analyzer

      # toml
      pkgs.taplo

      # git
      pkgs.git
      pkgs.delta
      pkgs.git-filter-repo
      pkgs.git-lfs

      pkgs.lldb
    ];
  };

  programs = {
    bash.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git.enable = true;

    home-manager.enable = true;

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    gpg = {
      enable = true;
    };

    zsh = { };

  };

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.enable = true;

  imports = [
    # ../dot-config/nix/file.nix
  ];

}
