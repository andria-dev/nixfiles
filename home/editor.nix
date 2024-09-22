{ pkgs, inputs, ... }:

{
	imports = [
		inputs.nvchad-nix.homeManagerModule
		inputs.vscode-server.homeModules.default
	];

	# Configure NvChad and neovim.
	programs.nvchad = {
		enable = true;
		neovim = inputs.neovim-nightly.packages.${pkgs.system}.default;
		backup = false;
		extraPackages = with pkgs; [ nil vimPlugins.nvim-nu ];
		extraConfig = builtins.readFile ../nixfiles/nvim.lua;
	};

	services.vscode-server.enable = true;
}

