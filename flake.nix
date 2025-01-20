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
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      nixvim,
    }:
    let
      # Define host-specific variables
      hostConfigurations = {
        quail = {
          system = "aarch64-darwin";
          configuration = ./machines/quail/configuration.nix;
          home = ./machines/quail/home.nix;
        };
        "Chris-Skalendas-MacBook-Pro" = {
          system = "aarch64-darwin";
          configuration = ./machines/honor/configuration.nix;
          home = ./machines/honor/home.nix;
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
        { host, gui }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${host.system};
          modules = [
            host.home
            ./modules/home-common.nix
            nixvim.homeManagerModules.nixvim
            ./modules/home/nixvim.nix
            ./modules/home/git.nix
            ./modules/home/zsh.nix
            (if gui then ./modules/home/gui.nix else ./modules/home/cli.nix)
          ];
        };

    in
    {
      nixosConfigurations = {
        hydrogen = buildNixosSystemConfig hostConfigurations.hydrogen;
      };

      darwinConfigurations = {
        quail = buildDarwinSystemConfig hostConfigurations.quail;
        "Chris-Skalendas-MacBook-Pro" =
          buildDarwinSystemConfig
            hostConfigurations."Chris-Skalendas-MacBook-Pro";
      };

      homeConfigurations = {
        "chris@hydrogen" = buildHomeConfig {
          host = hostConfigurations.hydrogen;
          gui = false;
        };
        "chris@quail" = buildHomeConfig {
          host = hostConfigurations.quail;
          gui = true;
        };
        "chris.skalenda" = buildHomeConfig {
          host = hostConfigurations."Chris-Skalendas-MacBook-Pro";
          gui = false;
        };
      };
    };
}
