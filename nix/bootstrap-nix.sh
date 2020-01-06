if ! type -P nix; then
	curl https://nixos.org/nix/install | sh
fi	
nix-build
nix-shell

