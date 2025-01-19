{
  description = "Configuration for multiple computers using flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
    }:
    let
      # Define host-specific variables
      hostConfigurations = {
        quail = {
          system = "aarch64-darwin";
          configuration = ./machines/quail/configuration.nix;
          home = ./machines/quail/home.nix;
        };

        hydrogen = {
          system = "x86_64-linux";
          configuration = ./machines/hydrogen/configuration.nix;
          home = ./machines/hydrogen/home.nix;
        };
      };

      # Helper to build nixos or darwin configurations
      buildNixosSystemConfig =
        host:
        nixpkgs.lib.nixosSystem {
          system = host.system;
          modules = [
            host.configuration
            ./modules/system-common.nix
          ];
        };
      buildDarwinSystemConfig =
        host:
        nix-darwin.lib.darwinSystem {
          system = host.system;
          modules = [
            host.configuration
            ./modules/system-common.nix
          ];
        };

      buildHomeConfig =
        host:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${host.system};
          modules = [
            host.home
            ./modules/home-common.nix
          ];
        };

    in
    {
      nixosConfigurations = {
        hydrogen = buildNixosSystemConfig hostConfigurations.hydrogen;
      };

      darwinConfigurations = {
        quail = buildDarwinSystemConfig hostConfigurations.quail;
      };

      homeConfigurations = {
        hydrogen = buildHomeConfig hostConfigurations.hydrogen;
        quail = buildHomeConfig hostConfigurations.quail;
      };
    };
}
