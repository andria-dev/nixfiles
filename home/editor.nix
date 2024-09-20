{ pkgs, inputs, ... }:

{
	imports = [ inputs.nvchad-nix.homeManagerModule ];

	# Configure NvChad and neovim.
	programs.nvchad = {
		enable = true;
		neovim = inputs.neovim-nightly.packages.${pkgs.system}.default;
		backup = false;
		extraPackages = with pkgs; [ nil ];
		extraConfig = builtins.readFile ../nixfiles/nvim.lua;
	};
}

