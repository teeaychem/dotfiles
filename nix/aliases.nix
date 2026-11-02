{ files }:
{ lib, ... }:
{
  xdg.configFile =
    let
      aliases = lib.mergeAttrsList (
        map (file: builtins.fromTOML (builtins.readFile file)) files
      );
    in
    {
      "fish/aliases.fish".text = lib.generators.toKeyValue {
        mkKeyValue = name: value: "abbr --add -- ${lib.escapeShellArg name} ${lib.escapeShellArg value}";
      } aliases;

      "zsh/aliases.zsh".text = lib.generators.toKeyValue {
        mkKeyValue = name: value: "alias -- ${lib.escapeShellArg "${name}=${value}"}";
      } aliases;
    };
}
