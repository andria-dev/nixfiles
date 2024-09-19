account:
{ pkgs, config, inputs, lib, ... }:

let
  toSshConfig = import ./generators/toSshConfig.nix lib;
in 

{
	imports = [ inputs.nvchad-nix.homeManagerModule ];
	home.packages = with pkgs; [ bat git ];

	# Configure NvChad and neovim.
	programs.nvchad = {
		enable = true;
		neovim = inputs.neovim-nightly.packages.${pkgs.system}.default;
		backup = false;
		extraPackages = with pkgs; [ nil ];
		extraConfig = builtins.readFile ./nixfiles/nvim.lua;
	};

	# Link nushell configuration files.
	programs.nushell = {
		enable = true;
		envFile.source = ./nixfiles/env.nu;
		configFile.source = ./nixfiles/config.nu;
	};

	# Configure starship and link the nushell starship init file.
	programs.starship = {
		enable = true;
		enableNushellIntegration = true;
		enableBashIntegration = true;
		settings = {
			add_newline = true;
			character = {
				success_symbol = "[➜](bold green)";
			};
			package = {
				disabled = true;
			};
			username = {
				show_always = true;
				format = "[$user]($style)";
			};
			hostname = {
				disabled = false;
				ssh_only = false;
				format = "[@$hostname$ssh_symbol]($style) ";
			};
			sudo = {
				disabled = false;
			};
			time = {
				disabled = false;
				use_12hr = true;
			};
		};
	};

	# Tell SSH to use 1Password's SSH agent.
	home.file.".ssh/config".text = toSshConfig {
		host."*" = {
			IdentityAgent = "${account.home}/.1password/agent.sock";
		};
	};
	programs.nushell.environmentVariables.SSH_AUTH_SOCK = "${account.home}/.1password/agent.sock";

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

	# Configure 1Password's SSH agent.
	services.ssh-agent.enable = true;
	home.file.".config/1Password/ssh/agent.toml".source = ./nixfiles/1password-ssh-agent.toml;

	home.stateVersion = "24.05";
}
