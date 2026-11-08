default: nix

home:
    home-manager switch --flake . -b backup

sketchybar: nix
    sketchybar --reload

[linux]
nix:
    nixos-rebuild switch --sudo --flake .# --impure

[macos]
nix:
    sudo nix run nix-darwin -- switch --flake .#

[linux]
nix-reboot:
    nixos-rebuild boot --sudo --flake .# --impure

format:
    treefmt

fix:
    statix fix .
    deadnix --edit .
    treefmt

fmt-check:
    treefmt --ci

lint:
    statix check .
    deadnix --fail .

typecheck:
    uv run ty check tests

test:
    uv run pytest

eval-check:
    nix eval --no-write-lock-file --json '.#darwinConfigurations' \
        --apply 'configs: builtins.mapAttrs (_: c: c.system.drvPath) configs'
    nix eval --no-write-lock-file --json '.#nixosConfigurations' \
        --apply 'configs: builtins.mapAttrs (_: c: c.config.system.build.toplevel.drvPath) (builtins.removeAttrs configs ["grouse"])'
    nix eval --no-write-lock-file --json '.#homeConfigurations' \
        --apply 'configs: builtins.mapAttrs (_: c: c.activationPackage.drvPath) configs'

eval-check-grouse:
    nix eval --no-write-lock-file --impure '.#nixosConfigurations.grouse.config.system.build.toplevel.drvPath'

check: lint fmt-check typecheck test eval-check
