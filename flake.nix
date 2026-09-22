{
  description = "BlueMoon";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Haskell builds via haskell.nix
    haskell-nix.url = "github:input-output-hk/haskell.nix";
    haskell-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Source filtering
    nix-filter.url = "github:numtide/nix-filter";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, haskell-nix, nix-filter, ... }@inputs:
    let
      system = "x86_64-linux";

      # Base nixpkgs with haskell.nix overlay
      pkgs = import nixpkgs {
        inherit system;
        config = haskell-nix.config;
        overlays = [
          haskell-nix.overlay
        ];
      };

      # Unstable packages for newer tools
      pkgsUnstable = import nixpkgs-unstable {
        inherit system;
      };

    in {
      # Packages
      packages.${system} = {
        blue-moon = pkgs.blue-moon;
        blue-moon-migrate = pkgs.blue-moon-migrate;
        blue-moon-src = pkgs.blue-moon-src;
        default = pkgs.blue-moon;
      };
}
