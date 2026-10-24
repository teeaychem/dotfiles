{ linkSources }:
{ config, lib, pkgs, ... }:
let
  linkFiles = linkSources { inherit config lib pkgs; };
in
{
  home.file = linkFiles {
    source = "personal";
    directory = config.home.homeDirectory;
  };
}
