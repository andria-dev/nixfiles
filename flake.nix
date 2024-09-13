{
	description = "WSL NixOS for software development!";

	# Install any input flakes we may need.
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
		# Install the modules for running NixOS in WSL.
		nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
		# Install home-manager for our user-wide configurations.
		home-manager.url = "github:nix-community/home-manager/release-24.05";

		# Neovim Nightly
		neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
		# Pull in the NvChad flake adaptation to download the NvChad config and install its plugin-manager to make neovim enjoyable.
		nvchad-nix.url = "github:nix-community/nix4nvchad";
		# Install nil, a nix language server.
		nil.url = "github:oxalica/nil#";
	};

	# Build the output that will configure our whole system.
	outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }@inputs:
	{
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			specialArgs = {
				inherit inputs;
			};
			modules = [
				nixos-wsl.nixosModules.default {
					system.stateVersion = "24.05";
					wsl.enable = true;
				}
				./overlays.nix
				./configuration.nix
				./users.nix
				home-manager.nixosModules.home-manager {
					home-manager = {
						extraSpecialArgs = { inherit inputs; };
						useGlobalPkgs = true;
						useUserPackages = true;
						users.andria = import ./home.nix;
					};
				}
			];
		};
	};
}

