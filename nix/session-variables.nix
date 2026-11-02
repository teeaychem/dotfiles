{ config }:
{
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
}
