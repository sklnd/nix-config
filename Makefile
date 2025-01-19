default: nix

.PHONY: home
home:
	home-manager switch --flake .#hydrogen

.PHONY: nix
nix:
	if [ "$(shell uname)" = "Linux" ]; then \
		sudo nixos-rebuild switch --flake .#; \
	elif [ "$(shell uname)" = "Darwin" ]; then \
		darwin-rebuild switch --flake .#; \
	else \
		echo "Unsupported OS"; \
		exit 1; \
	fi
