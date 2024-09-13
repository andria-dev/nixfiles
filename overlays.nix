{ pkgs, inputs, ... }:

{
	nixpkgs.overlays = [
		(final: prev: {
			nvchad = inputs.nvchad-nix.packages."${pkgs.system}".nvchad;
		})
	];
}
