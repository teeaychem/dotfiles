{ config, linkFiles, ... }:
{
  home.file = linkFiles {
    source = "personal";
    directory = config.home.homeDirectory;
  };
}
