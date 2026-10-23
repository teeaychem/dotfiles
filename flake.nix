{
  description = "Dotfiles with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
    }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      # Return target names relative to directory, mapped to paths beneath source.
      # Preserve source-relative layout beneath target. Every (path: type: bool)
      # filter must allow an entry; rejected directories are not traversed.
      # Discovery does not copy file contents into the store.
      mapDirFilewise =
        { directory, source, target, filters ? [ ] }:
        let
          inherit (nixpkgs) lib;
          sourcePrefix = "${toString source}/";
          targetPrefix = lib.removePrefix "${directory}/" "${target}/";
          files = lib.fileset.toList (
            lib.fileset.fromSource (lib.cleanSourceWith {
              src = /. + toString source;
              filter = path: type: lib.all (filter: filter path type) filters;
            })
          );
        in
        lib.listToAttrs (
          map (file: {
            name = targetPrefix + lib.removePrefix sourcePrefix (toString file);
            value = toString file;
          }) files
        );

      current = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};
        modules = [
          self.homeModules.default
          {
            home.username = builtins.getEnv "USER";
            home.homeDirectory = builtins.getEnv "HOME";
            dotfiles.checkout = builtins.getEnv "PWD";
          }
        ];
      };
    in
    {
      lib.mapDirFilewise = mapDirFilewise;
      homeModules.default = import ./nix/home.nix { inherit mapDirFilewise; };

      homeConfigurations = {
        inherit current;
        current-personal = current.extendModules {
          modules = [ { dotfiles.personal = true; } ];
        };
      };

      apps = nixpkgs.lib.genAttrs systems (system: {
        home-manager = {
          type = "app";
          program = "${home-manager.packages.${system}.home-manager}/bin/home-manager";
        };
      });
    };
}
