{
  config,
  lib,
  linkFiles,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles;
  platform = pkgs.stdenv.hostPlatform.parsed.kernel.name;

  /*nixfmt:disable*/
  configLinks = map (source: linkFiles {
    inherit source;
    directory = config.xdg.configHome;
  }) [
    "dotconfig"
  ];

  homeLinks = map (source: linkFiles {
    inherit source;
    directory = config.home.homeDirectory;
  }) [
    "homedir"
    "dotconfig/zsh/.homedir/.zshenv"
  ];

  scriptLinks = map (source: linkFiles {
    inherit source;
    directory = "${config.home.homeDirectory}/.local/bin";
  }) [
    "scripts/common"
    "scripts/${platform}"
  ];
/*nixfmt:enable*/

in
{
  options.dotfiles = {
    checkout = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/dotfiles";
      description = "Absolute path to the writable dotfiles checkout.";
    };
  };

  config = {
    assertions = [
      {
        assertion = lib.hasPrefix "/" cfg.checkout && !(lib.hasPrefix "/nix/store/" cfg.checkout);
        message = "dotfiles.checkout must point to an absolute, writable checkout path.";
      }
    ];

    home.sessionVariables = {
      XDG_DESKTOP_DIR = "${config.home.homeDirectory}/Desktop";
      XDG_DOWNLOAD_DIR = "${config.home.homeDirectory}/Downloads";
      XDG_TEMPLATES_DIR = "${config.home.homeDirectory}/Templates";
      XDG_PUBLICSHARE_DIR = "${config.home.homeDirectory}/Public";
      XDG_DOCUMENTS_DIR = "${config.home.homeDirectory}/Documents";
      XDG_MUSIC_DIR = "${config.home.homeDirectory}/Music";
      XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
      XDG_VIDEOS_DIR = "${config.home.homeDirectory}/Videos";

      HOMEBREW_BAT = "1";
      HOMEBREW_NO_AUTO_UPDATE = "1";
      HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS = "1";
      HOMEBREW_NO_ENV_HINTS = "1";

      EDITOR = "nvim";
      PAGER = "less";
      LESS = "-RF";
      MANPAGER = "nvim +Man!";
      FD_OPTIONS = "--hidden --follow";
      FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git";

      OPAMROOT = "${config.xdg.dataHome}/opam";
      GFORTHHIST = "${config.xdg.stateHome}/gforth/history";
      PYTHONPYCACHEPREFIX = "${config.xdg.cacheHome}/python_cache";
      PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";
      IPYTHONDIR = "${config.xdg.cacheHome}/ipython";
      MPLCONFIGDIR = "${config.xdg.cacheHome}/matplotlib";
      DICTIONARY = "en_GB";
      DICPATH = "${config.xdg.dataHome}/hunspell";
      LESSHISTFILE = "${config.xdg.stateHome}/less/history";
      KERAS_HOME = "${config.xdg.dataHome}/keras";
      ELAN_HOME = "${config.home.homeDirectory}/.local/opt/elan";
    };

    home.sessionPath = [
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.sessionVariables.ELAN_HOME}/bin"
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      "/opt/homebrew/sbin"
      "/opt/homebrew/bin"
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      "/home/linuxbrew/.linuxbrew/sbin"
      "/home/linuxbrew/.linuxbrew/bin"
    ];

    # Provide the same session environment in fish syntax for the native config.
    home.packages = [
      (pkgs.runCommandLocal "hm-session-vars.fish" { nativeBuildInputs = [ pkgs.buildPackages.babelfish ]; } ''
        mkdir -p "$out/etc/profile.d"
        babelfish < ${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh > "$out/etc/profile.d/hm-session-vars.fish"
      '')
    ];

    xdg.enable = true;

    # Keep these application configs in their native formats.
    home.file = lib.mergeAttrsList (homeLinks ++ scriptLinks);

    xdg.configFile = lib.mergeAttrsList configLinks;
  };
}
