default: nix

.PHONY: home
home:
	home-manager switch --flake . -b backup

.PHONY: sketchybar
sketchybar: nix
	sketchybar --reload


.PHONY: nix
nix:
	@if [ "$(shell uname)" = "Linux" ]; then \
		nixos-rebuild switch --sudo --flake .# --impure; \
	elif [ "$(shell uname)" = "Darwin" ]; then \
		sudo nix run nix-darwin -- switch --flake .#; \
	else \
		echo "Unsupported OS"; \
		exit 1; \
	fi

.PHONY: nix-reboot
nix-reboot:
	@if [ "$(shell uname)" = "Linux" ]; then \
		nixos-rebuild boot --sudo --flake .# --impure; \
	else \
		echo "Unsupported OS"; \
		exit 1; \
	fi

.PHONY: format
format:
	treefmt

.PHONY: fix
fix:
	statix fix .
	deadnix --edit .
	treefmt

.PHONY: fmt-check
fmt-check:
	treefmt --ci

.PHONY: lint
lint:
	statix check .
	deadnix --fail .

.PHONY: typecheck
typecheck:
	uv run ty check tests

.PHONY: test
test:
	uv run pytest

.PHONY: eval-check
eval-check:
	nix eval --no-write-lock-file --json '.#darwinConfigurations' \
		--apply 'configs: builtins.mapAttrs (_: c: c.system.drvPath) configs'
	nix eval --no-write-lock-file --json '.#nixosConfigurations' \
		--apply 'configs: builtins.mapAttrs (_: c: c.config.system.build.toplevel.drvPath) (builtins.removeAttrs configs ["grouse"])'
	nix eval --no-write-lock-file --json '.#homeConfigurations' \
		--apply 'configs: builtins.mapAttrs (_: c: c.activationPackage.drvPath) configs'

.PHONY: eval-check-grouse
eval-check-grouse:
	nix eval --no-write-lock-file --impure '.#nixosConfigurations.grouse.config.system.build.toplevel.drvPath'

.PHONY: check
check: lint fmt-check typecheck test eval-check
