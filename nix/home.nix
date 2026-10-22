{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles;
  platform = pkgs.stdenv.hostPlatform.parsed.kernel.name;

  commonConfigs = [
    ".luarc.json"
    "alacritty.toml"
    "bat"
    "emacs"
    "espanso"
    "fish"
    "git"
    "hunspell"
    "latexmk"
    "nvim"
    "pycodestyle"
    "shell"
    "tmux"
    "vim"
    "zellij"
    "zsh"
  ];

  platformConfigs = {
    darwin = [
      "ghostty"
      "hammerspoon"
    ];
  };

  configs = commonConfigs ++ (platformConfigs.${platform} or [ ]);

  fileByFileConfigs = [
    # Runtime-generated files stay outside the checkout.
    "emacs"
    "zsh"

    # Existing local additions stay alongside the managed files.
    "shell"
  ];

  linkDirectories =
    { directory, sources }:
    let
      mapDirFilewise = import ./map-dir-filewise.nix { inherit lib directory; };
    in
    lib.mergeAttrsList (
      map (
        { source, ... }@args:
        mapDirFilewise (
          args
          // {
            source = /. + "${cfg.checkout}/${source}";
          }
        )
      ) sources
    );

  homeDirectories = [
    {
      source = "homedir";
      target = config.home.homeDirectory;
    }
    {
      source = "scripts/common";
      target = "${config.home.homeDirectory}/.local/bin";
    }
    {
      source = "scripts/${platform}";
      target = "${config.home.homeDirectory}/.local/bin";
    }
  ]
  ++ lib.optional cfg.personal {
    source = "personal";
    target = config.home.homeDirectory;
  };

  configDirectories = map (name: {
    source = "dotconfig/${name}";
    target = "${config.xdg.configHome}/${name}";
  }) (lib.intersectLists fileByFileConfigs configs);

  homeLinks = linkDirectories {
    directory = config.home.homeDirectory;
    sources = homeDirectories;
  };
  configLinks = linkDirectories {
    directory = config.xdg.configHome;
    sources = configDirectories;
  };
  directConfigLinks = lib.genAttrs (lib.subtractLists fileByFileConfigs configs) (
    name: "${cfg.checkout}/dotconfig/${name}"
  );
  fileDefaults = lib.mapAttrs (
    _: source: {
      source = lib.mkDefault (config.lib.file.mkOutOfStoreSymlink source);
    }
  );

in
{
  options.dotfiles = {
    checkout = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/dotfiles";
      description = "Absolute path to the writable dotfiles checkout.";
    };
    personal = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Include the opt-in personal dotfiles layer.";
    };
  };

  config = {
    assertions = [
      {
        assertion = lib.hasPrefix "/" cfg.checkout && !(lib.hasPrefix "/nix/store/" cfg.checkout);
        message = "dotfiles.checkout must point to an absolute, writable checkout path.";
      }
    ];

    home.stateVersion = lib.mkDefault "26.05";
    xdg.enable = true;

    # Keep these application configs in their native formats.
    home.file = fileDefaults homeLinks // {
      ".zshenv".source = lib.mkDefault (
        config.lib.file.mkOutOfStoreSymlink "${cfg.checkout}/dotconfig/zsh/.homedir/.zshenv"
      );
    };
    xdg.configFile = fileDefaults (configLinks // directConfigLinks);
  };
}
