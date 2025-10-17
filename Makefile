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
		nixos-rebuild switch --use-remote-sudo --flake .#; \
	elif [ "$(shell uname)" = "Darwin" ]; then \
		sudo nix run nix-darwin -- switch --flake .#; \
	else \
		echo "Unsupported OS"; \
		exit 1; \
	fi

.PHONY: format
format:
	treefmt
