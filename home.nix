{ pkgs, inputs, ... }:

{
	imports = [ inputs.nvchad-nix.homeManagerModule ];
	home.packages = with pkgs; [ nushell starship ];

	# Configure NvChad and neovim.
	programs.nvchad = {
		enable = true;
		neovim = inputs.neovim-nightly.packages.${pkgs.system}.default;
		backup = false;
		extraPackages = with pkgs; [ nil ];
		extraConfig = builtins.readFile ./nixfiles/nvim.lua;
	};

	# Link nushell configuration files.
	home.file.".config/nushell/env.nu".source = ./nixfiles/env.nu;
	home.file.".config/nushell/config.nu".source = ./nixfiles/config.nu;

	# Configure starship and link the nushell starship init file.
	programs.starship = {
		enable = true;
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
	home.file.".cache/starship/init.nu".source = ./nixfiles/starship.nu;

	home.stateVersion = "24.05";
}
