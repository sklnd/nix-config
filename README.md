# My nix configuration

This repo defines configuration for all of my nix-based systems. The repo includes nix configurations for:
- NixOS systems
- MacOS systems (using nix-darwin)
- home-manager configuration for my homedir

## Repo organization
I'm using a flake to define the configuration organization, which then splinters out to machine-specific configuration and common functionality.
- Systems are configured under `/machines`
- Common functionality lives within modules.

## Usage
Install the repo's tools with `mise install`. 


Tasks use [just](https://just.systems/);

System configurations are matched on hostname.
The default recipe switches the system configuration:
```bash
just
```

Home configuration is matched on `user@host`.
To switch to the latest home-manager configuration:
```bash
just home
```

A formatter is included using treefmt and nixfmt for nix files. To run:
```bash
just format
```
