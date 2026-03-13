{
  description = "dotfiles";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin-unstable = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nix-darwin,
      home-manager,
      ...
    }@inputs:

    let
      inherit (self) outputs;

      system = "aarch64-darwin";

      pkg-config = {
        allowUnfree = true;
        allowBroken = true;
        allowInsecure = false;
        allowUnsupportedSystem = false;
      };

      common-overlays = [
        (import inputs.emacs-overlay)
      ]
      ++ (
        let
          path = ./overlays;
        in
        with builtins;
        map (n: import (path + ("/" + n))) (
          filter (n: match ".*\\.nix" n != null || pathExists (path + ("/" + n + "/default.nix"))) (
            attrNames (readDir path)
          )
        )
      );

      linux-pkgs = import nixpkgs {
        system = "aarch64-linux";
        config = pkg-config;
        overlays = common-overlays ++ [ ];
      };

      darwin-pkgs = import nixpkgs {
        hostPlatform = "aarch64-darwin";
        system = "aarch64-darwin";
        config = pkg-config;
        overlays = common-overlays ++ [ ];
      };

      pkgs-unstable = import nixpkgs-unstable {
        hostPlatform = "aarch64-darwin";
        system = "aarch64-darwin";
        config = pkg-config;
        overlays = [ ];
      };

    in

    {
      darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
        inherit system;
        pkgs = darwin-pkgs;
        specialArgs = { inherit darwin-pkgs pkgs-unstable; };
        modules = [ ./darwin/darwin.nix ];
      };

      homeConfigurations = {
        sparkes = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = darwin-pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./darwin/home.nix ];
        };
      };

    };
}
