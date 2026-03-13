{
  inputs,
  outputs,
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
  };

  programs = {
    home-manager.enable = true;
  };

  imports = [
    # ../dot-config/nix/file.nix
  ];

}
