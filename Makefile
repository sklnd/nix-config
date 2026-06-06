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

.PHONY: check
check:
	statix check .
	deadnix .
