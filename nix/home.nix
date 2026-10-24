{ linkSources }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles;
  platform = pkgs.stdenv.hostPlatform.parsed.kernel.name;

  linkFiles = linkSources { inherit config lib pkgs; };

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

    xdg.enable = true;

    # Keep these application configs in their native formats.
    home.file = lib.mergeAttrsList (homeLinks ++ scriptLinks);

    xdg.configFile = lib.mergeAttrsList configLinks;
  };
}
