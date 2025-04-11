{
  description = "Configuration for multiple computers using flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
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
      # Automatically generate host configurations
      hostConfigurations = builtins.listToAttrs (
        map (machine: {
          name = machine;
          value =
            let
              system = import ./machines/${machine}/system.nix { };
            in
            {
              hostPlatform = system.hostPlatform;
              configuration = ./machines/${machine}/configuration.nix;
              home = ./machines/${machine}/home.nix;
            };
        }) (builtins.attrNames (builtins.readDir ./machines))
      );

      # Helper to build nixos or darwin configurations
      buildNixosSystemConfig =
        host:
        nixpkgs.lib.nixosSystem {
          system = host.hostPlatform;
          modules = [
            host.configuration
            ./modules/system-common.nix
          ];
        };
      buildDarwinSystemConfig =
        host:
        nix-darwin.lib.darwinSystem {
          system = host.hostPlatform;
          modules = [
            host.configuration
            ./modules/system-common.nix
          ];
        };

      buildHomeConfig =
        { host, gui }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${host.hostPlatform};
          modules = [
            host.home
            nixvim.homeManagerModules.nixvim
            ./modules/home/home.nix
            ./modules/home/nixvim.nix
            ./modules/home/git.nix
            ./modules/home/tmux.nix
            ./modules/home/zsh.nix
            (if gui then ./modules/home/gui.nix else ./modules/home/cli.nix)
          ];
        };

    in
    {
      nixosConfigurations = {
        hydrogen = buildNixosSystemConfig hostConfigurations.hydrogen;
        helium = buildNixosSystemConfig hostConfigurations.helium;
      };

      darwinConfigurations = {
        quail = buildDarwinSystemConfig hostConfigurations.quail;
        "Chris-Skalendas-MacBook-Pro" = buildDarwinSystemConfig hostConfigurations.honor;
      };

      homeConfigurations = {
        "chris@hydrogen" = buildHomeConfig {
          host = hostConfigurations.hydrogen;
          gui = false;
        };
        "chris@helium" = buildHomeConfig {
          host = hostConfigurations.helium;
          gui = false;
        };
        "chris@quail" = buildHomeConfig {
          host = hostConfigurations.quail;
          gui = true;
        };
        "chris.skalenda" = buildHomeConfig {
          host = hostConfigurations.honor;
          gui = true;
        };
      };
    };
}
