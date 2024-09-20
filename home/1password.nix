{ lib, pkgs, ... }:

{
	# Configure 1Password's SSH agent.
	home.file.".config/1Password/ssh/agent.toml".source = ../nixfiles/1password-ssh-agent.toml;

	# Start 1Password automatically.
	systemd.user.services."1password" = {
		Unit = {
			Description = "1Password desktop app";
			Documentation = "https://support.1password.com";
		};

		Service = {
			Type = "simple";
			Environment = "DISPLAY=:0";
			ExecStart = "${lib.getExe pkgs._1password-gui} --silent";
			Restart = "on-abnormal";
			RestartSec = "5s";
			OOMPolicy = "continue";
			KeyringMode = "inherit";
		};

		Install = {
			WantedBy = [ "default.target" ];
		};
	};
}

