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
  /*nixfmt:enable*/

  /*nixfmt:disable*/
  homeLinks = map (source: linkFiles {
    inherit source;
    directory = config.home.homeDirectory;
  }) [
    "homedir"
    "dotconfig/zsh/.homedir/.zshenv"
  ];
  /*nixfmt:enable*/

  /*nixfmt:disable*/
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
  imports = [
    (import ./aliases.nix {
      files = [ ../dotconfig/shell/aliases.toml ];
    })
  ];

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

    home.sessionVariables = lib.mergeAttrsList (
      map (file: import file { inherit config; }) [
        ./session-variables.nix
      ]
    );

    home.sessionPath = [
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.sessionVariables.ELAN_HOME}/bin"
    ];

    home.packages = [
      pkgs.bat
      pkgs.fd
      pkgs.fzf
      pkgs.gh
      pkgs.git
      pkgs.jq
      pkgs.ripgrep
      pkgs.shellcheck
      pkgs.tmux
      pkgs.zoxide

      # Provide the same session environment in fish syntax for the native config.
      (pkgs.runCommandLocal "hm-session-vars.fish"
        { nativeBuildInputs = [ pkgs.buildPackages.babelfish ]; }
        ''
          mkdir -p "$out/etc/profile.d"
          babelfish < ${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh > "$out/etc/profile.d/hm-session-vars.fish"
        ''
      )
    ];

    xdg.enable = true;

    # Keep these application configs in their native formats.
    home.file = lib.mergeAttrsList (homeLinks ++ scriptLinks);

    xdg.configFile = lib.mergeAttrsList configLinks;
  };
}
