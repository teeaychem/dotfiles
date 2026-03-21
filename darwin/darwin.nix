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
      zsh
    ];

    systemPackages = [
      pkgs.clang-tools
      pkgs.nixfmt-rfc-style
      pkgs.xld

      # nix
      pkgs.nil

      # SAT/SMT
      pkgs.cvc5
    ];
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
