{ mapDirFilewise }:
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
    "tex-fmt"
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

  # Return a (path: type: bool) predicate from root/.gitignore.
  # Interpret patterns relative to root; a missing file permits all paths.
  gitignoreFilterFor =
    root:
    let
      ignoreFile = root + "/.gitignore";
      rules = lib.optionalString (builtins.pathExists ignoreFile) (builtins.readFile ignoreFile);
    in
    pkgs.nix-gitignore.gitignoreFilter rules root;

  repositoryFilter = gitignoreFilterFor (/. + cfg.checkout);

  # Return a map of destination filenames to absolute source paths.
  # Each sources entry has a checkout-relative source and an absolute target beneath directory.
  # Returned destination names are relative to directory.
  # For a directory source, include its files beneath target, preserving their layout and applying both ignore filters.
  # For a file, use target as its name.
  linkSources =
    { directory, sources }:
    lib.mergeAttrsList (
      map (
        { source, ... }@args:
        let
          sourcePath = /. + "${cfg.checkout}/${source}";
        in
        if builtins.readFileType sourcePath == "directory" then
          mapDirFilewise (
            args
            // {
              inherit directory;
              source = sourcePath;
              filters = [
                repositoryFilter
                (gitignoreFilterFor sourcePath)
              ];
            }
          )
        else
          { ${lib.removePrefix "${directory}/" args.target} = toString sourcePath; }
      ) sources
    );

  homeSources = [
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

  configSources = map (name: {
    source = "dotconfig/${name}";
    target = "${config.xdg.configHome}/${name}";
  }) configs;

  homeLinks = linkSources {
    directory = config.home.homeDirectory;
    sources = homeSources;
  };
  configLinks = linkSources {
    directory = config.xdg.configHome;
    sources = configSources;
  };
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
    xdg.configFile = fileDefaults configLinks;
  };
}
