{ lib, pkgs,  ... }:

{
	# NixOS-WSL options
	wsl = {
		enable = true;
		defaultUser = "andria";
		wslConf = {
			network.hostname = "nixos";
			user.default = "andria";
		};
	};

	# Inform nixpkgs what platform to get/build binaries for.
	nixpkgs.hostPlatform.system = "x86_64-linux";

	# Experimental features
	nix.settings.experimental-features = "nix-command flakes";

	packages = with pkgs; [ git ];

	# Enable automatic nix garbage collection for users.
	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 7d";
	};

	# Set what unfree packages are allowed.
	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
		"1password-cli"
		"1password"
	];

	# Enable 1password for andria.
	programs._1password.enable = true;
	programs._1password-gui = {
		enable = true;
		polkitPolicyOwners = ["andria"];
	};

	programs.ssh.startAgent = true;
}

