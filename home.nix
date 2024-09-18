account:
{ pkgs, config, inputs, lib, ... }:

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
	# home.file.".cache/starship/init.nu".source = ./nixfiles/starship.nu;

	# Configure SSH to use 1Password's SSH agent.
	home.file.".ssh/config".text = ''
		Host *
			IdentityAgent ${account.home}/.1password/agent.sock
	'';
	programs.nushell.environmentVariables.SSH_AUTH_SOCK = "${account.home}/.1password/agent.sock";

	# Load .gitconfig and replace any dynamic env-like variables.
	home.file.".gitconfig".text = 
		let
			GPG_SSH_PROGRAM_PATH = lib.getExe' pkgs._1password-gui "op-ssh-sign";
			gitConfig = builtins.readFile ./nixfiles/gitconfig;
		in builtins.replaceStrings [ "GPG_SSH_PROGRAM_PATH" ] [ GPG_SSH_PROGRAM_PATH ] gitConfig;
	services.ssh-agent.enable = true;
	# Configure 1Password's SSH agent.
	home.file.".config/1Password/ssh/agent.toml".source = ./nixfiles/1password-ssh-agent.toml;

	home.stateVersion = "24.05";
}
