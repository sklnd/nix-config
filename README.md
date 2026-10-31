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
System configurations are matched on hostname.
The default make target switches the system configuration:
```bash
make
```

Home configuration is matched on `user@host`.
To switch to the latest home-manager configuration:
```bash
make home
```

A formatter is included using treefmt and nixfmt for nix files. To run:
```bash
make format
```

## Reusing shared configuration

The flake exports `lib.buildDarwinSystemConfig` and `lib.buildHomeConfig` for
composing the shared modules in other configurations. Both accept an optional
`extraModules` list, which defaults to empty. Consumers supply their own host
configuration and can add modules without copying the shared preferences.

The root outputs and Makefile continue to configure the personal machines.
