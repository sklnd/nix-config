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
    nvim = {
      url = "github:sklnd/nvim";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nix-darwin,
    nvim,
    llm-agents,
    ...
  }: let
    # Custom packages overlay
    customPackages = final: _rev: {
      snd-ctl = final.callPackage ./pkgs/snd-ctl.nix {};
    };

    # Automatically generate host configurations
    hostConfigurations = builtins.listToAttrs (
      map (machine: {
        name = machine;
        value = let
          system = import ./machines/${machine}/system.nix {};
        in {
          inherit (system) hostPlatform;
          configuration = ./machines/${machine}/configuration.nix;
          home = ./machines/${machine}/home.nix;
        };
      }) (builtins.attrNames (builtins.readDir ./machines))
    );

    # Helper to build nixos or darwin configurations
    buildNixosSystemConfig = host:
      nixpkgs.lib.nixosSystem {
        system = host.hostPlatform;
        specialArgs = {inherit nvim host;};
        modules = [
          host.configuration
          ./modules/system-common.nix
          ./modules/nvim.nix
          {nixpkgs.overlays = [customPackages];}
        ];
      };
    buildDarwinSystemConfig = host:
      nix-darwin.lib.darwinSystem {
        system = host.hostPlatform;
        specialArgs = {inherit nvim host;};
        modules = [
          host.configuration
          ./modules/system-common.nix
          ./modules/nvim.nix
          {nixpkgs.overlays = [customPackages];}
        ];
      };

    buildHomeConfig = {
      host,
      gui,
    }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${host.hostPlatform};
        extraSpecialArgs = {inherit nvim host llm-agents;};
        modules = [
          host.home
          ./modules/home/home.nix
          ./modules/home/git.nix
          ./modules/home/tmux.nix
          ./modules/home/zsh.nix
          (
            if gui
            then ./modules/home/gui.nix
            else {}
          )
        ];
      };
  in {
    nixosConfigurations = {
      hydrogen = buildNixosSystemConfig hostConfigurations.hydrogen;
      helium = buildNixosSystemConfig hostConfigurations.helium;
      grouse = buildNixosSystemConfig hostConfigurations.grouse;
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
      "chris@grouse" = buildHomeConfig {
        host = hostConfigurations.grouse;
        gui = true;
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

    packages = nixpkgs.lib.genAttrs ["aarch64-darwin" "x86_64-darwin"] (system: {
      snd-ctl = nixpkgs.legacyPackages.${system}.callPackage ./pkgs/snd-ctl.nix {};
    });
  };
}
