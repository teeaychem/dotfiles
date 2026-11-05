{
  config,
  lib,
  pkgs,
  ...
}:
let
  fish = {
    name = "fish";
    sessionExtension = "fish";
  };
  zsh = {
    name = "zsh";
    sessionExtension = "sh";
  };

  reload = shell: ''
    unset __HM_SESS_VARS_SOURCED
    # Use the native source builtin; these files are already shell-specific.
    builtin source ${lib.escapeShellArg "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.${shell.sessionExtension}"}
    builtin source ${lib.escapeShellArg "${config.xdg.configHome}/${shell.name}/aliases.${shell.name}"}
  '';
in
{
  xdg.configFile = {
    "fish/functions/reload-home-manager.fish".source =
      pkgs.runCommandLocal "reload-home-manager.fish"
        {
          nativeBuildInputs = [ pkgs.buildPackages.babelfish ];
          script = pkgs.writeText "reload-home-manager.sh" ''
            reload-home-manager() {
              ${reload fish}
            }
          '';
        }
        ''
          babelfish < "$script" > "$out"
        '';

    "zsh/functions/reload-home-manager".text = reload zsh + "rehash\n";
  };
}
