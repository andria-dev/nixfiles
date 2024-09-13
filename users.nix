{ pkgs, ... }:
{
 # Create a user account for Andria.
	users.users.andria = {
		isNormalUser = true;
		home = "/home/andria";
		description = "Andria Brown";
		shell = pkgs.nushell;
		extraGroups = [ "wheel" ];
	}; 
}
