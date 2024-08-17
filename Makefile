.PHONY: home
home:
	home-manager switch --flake .#personal

.PHONY: darwin
darwin:
	darwin-rebuild switch --flake .#quail
