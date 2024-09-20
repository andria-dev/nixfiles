{ ... }:

{
	# Link nushell configuration files.
	programs.nushell = {
		enable = true;
		envFile.source = ../nixfiles/env.nu;
		configFile.source = ../nixfiles/config.nu;
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
}

