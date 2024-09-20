{ lib, pkgs, ... }:

{
	home.packages = with pkgs; [ git ];

	# Git config
	home.file.".gitconfig".text = lib.generators.toGitINI {
		init.defaultBranch = "main";
		safe.directory = "/etc/nixos";

		user = {
			name = "Andria Brown";
			email = "andria_girl@proton.me";
			signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINO4lgVsbIuVZJ5VgIx6oZ0jafPLUrNewpLS2Q63Gqd0";
		};

		gpg.format = "ssh";
		"gpg \"ssh\"".program = lib.getExe' pkgs._1password-gui "op-ssh-sign";

		commit.gpgsign = true;
		tag.gpgsign = true;

		core.editor = "nvim";
	};
}

