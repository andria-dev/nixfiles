account:
{ pkgs, config, inputs, lib, ... }:

let
  toSshConfig = import ../generators/toSshConfig.nix lib;
in 

{
	imports = [
		./shell.nix
		./editor.nix
		./git.nix
		./1password.nix
	];
	home.packages = with pkgs; [ bat ];

	# SSH config
	home.file.".ssh/config".text = toSshConfig {
		host."*" = {
			IdentityAgent = "${account.home}/.1password/agent.sock";
		};
	};
	programs.nushell.environmentVariables.SSH_AUTH_SOCK = "${account.home}/.1password/agent.sock";
	services.ssh-agent.enable = true;

	systemd.user.startServices = "sd-switch";

	home.stateVersion = "24.05";
}
