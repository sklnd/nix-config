# My nix configuration

This repo defines configuration for all of my nix-based systems.  it repo includes nix configurations for:
- NixOS systems
- MacOS systems (using nix-darwin)
- home-manager configuration for my homedir

## Repo organization
I'm using a flake to define the configuration organization, which then splinters out to machine-specific configuration and common functionality.
- Systems are configured under `/machines`
- Common functionality lives within modules.

## Usage
Install the repo's tools with `mise install`. Tasks use [just](https://just.systems/);
run `just --list` to see the available recipes. System-switching recipes are selected
automatically for Linux or macOS; `just nix-reboot` is Linux-only.

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

## Checks

Python checks use uv; the tests also require Bash and jq.
```bash
just lint       # Nix linting
just fmt-check  # Check formatting without changing files
just typecheck  # Check Python types with ty
just test       # Run pytest
just eval-check # Evaluate all homes and systems except Grouse’s system
just check      # Run all checks above
```
