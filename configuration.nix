# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ pkgs, ... }:

{
	# Inform nixpkgs what platform to get/build binaries for.
	nixpkgs.hostPlatform.system = "x86_64-linux";

	# Global packages
	environment.systemPackages = with pkgs; [ git ];

	# Experimental features
	nix.settings.experimental-features = "nix-command flakes";

	# Enable automatic nix garbage collection for users.
	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 7d";
	};
}

