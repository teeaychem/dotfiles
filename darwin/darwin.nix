{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  # $ nix-env -qaP
  nix.enable = false;

  environment = {
    shells = with pkgs; [
      bash
      zsh
    ];

    systemPackages = [
      pkgs.bat
      pkgs.bitwise
      pkgs.clang-tools
      pkgs.cmake
      pkgs.coreutils
      pkgs.delta
      pkgs.direnv
      pkgs.fd
      pkgs.fq
      pkgs.fzf
      pkgs.gersemi # cmake formatter
      pkgs.gnugrep
      pkgs.gnupg
      pkgs.hunspell
      pkgs.imagemagick
      pkgs.keepassxc
      pkgs.keka
      pkgs.lazygit
      pkgs.lldb
      pkgs.neovim
      pkgs.nixfmt-rfc-style
      pkgs.pass
      pkgs.pkg-configUpstream # ?pkg-config fails
      pkgs.prettier
      pkgs.qemu
      pkgs.ripgrep
      pkgs.starship
      pkgs.tmux
      pkgs.typos
      pkgs.xld
      pkgs.yazi
      pkgs.zoxide

      pkgs.tree-sitter

      # emacs
      pkgs.emacs-derived-plus
      pkgs.universal-ctags

      # git
      pkgs.git
      pkgs.delta
      pkgs.git-filter-repo
      pkgs.git-lfs

      # latex
      pkgs.texlab

      # lua
      pkgs.luajitPackages.luarocks

      # markdown
      pkgs.comrak # GF(Markdown)

      # nix
      pkgs.nil

      # python
      pkgs.python3
      pkgs.ruff
      pkgs.uv
      pkgs-unstable.ty

      # rust
      # pkgs.rust-analyzer

      # SAT/SMT
      pkgs.cvc5
      pkgs.z3

      # sh
      pkgs.shfmt
      pkgs.bash-language-server # mostly works for zsh

      # toml
      pkgs.taplo
    ];
  };

  fonts.packages = [
    pkgs.nerd-fonts."m+"
  ];

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    taps = [
      # "d12frosted/emacs-plus"
      "kgarner7/feishin"
    ];
    brews = [
      # "emacs-plus@30"
      # "llvm"
      "navidrome"
    ];
    casks = [
      "appcleaner"
      "feishin"
      "hammerspoon"
      "iina"
      "raycast"
      "rectangle"
      "skim"
      "vlc"
    ];
    caskArgs.no_quarantine = true;
  };

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  programs = {

    direnv = {
      package = pkgs.direnv;
      silent = false;
      loadInNixShell = true;
      direnvrcExtra = "";
      nix-direnv = {
        enable = true;
        package = pkgs.nix-direnv;
      };
    };

    zsh.enable = true;
  };

  system = {
    configurationRevision = null;
    stateVersion = 6;
    primaryUser = "sparkes";

    defaults = {
      dock.autohide = true;
      NSGlobalDomain = {
        AppleFontSmoothing = 0;
        AppleICUForce24HourTime = true;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        AppleShowScrollBars = "Always";
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  users = {
    knownUsers = [ config.system.primaryUser ];
    users.${config.system.primaryUser} = {
      uid = 501;
      shell = pkgs.zsh;
    };
  };
}
