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
      homeModules.default = import ./nix/home.nix;

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
