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
      linkSources = import ./nix/link-sources.nix;

      # Assemble a configuration with a shared compatibility baseline.
      # Default to the running system; read user and checkout paths at evaluation.
      mkHome =
        {
          system ? builtins.currentSystem,
          stateVersion ? "26.05",
          modules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            self.homeModules.default
            {
              home.username = builtins.getEnv "USER";
              home.homeDirectory = builtins.getEnv "HOME";
              home.stateVersion = stateVersion;
              dotfiles.checkout = builtins.getEnv "PWD";
            }
          ]
          ++ modules;
        };
    in
    {
      homeModules.default = import ./nix/home.nix { inherit linkSources; };

      homeConfigurations = {
        mbp = mkHome {
          system = "aarch64-darwin";
          modules = [ (import ./nix/personal.nix { inherit linkSources; }) ];
        };

        # A generic entry.
        portable = mkHome { };
      };

      apps = nixpkgs.lib.genAttrs systems (system: {

        home-manager = {
          # Expose home manager through `nix run .#home-manager`.
          type = "app";
          program = "${home-manager.packages.${system}.home-manager}/bin/home-manager";
        };
      });
    };
}
