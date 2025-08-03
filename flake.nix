{
  description = "Nixessity neovim plugin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    bcfmt.url = "github:brandishcode/brandishcode-formatter";
    nixessitycore.url = "github:brandishcode/nixessitycore?ref=v1.1.2-alpha";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      bcfmt,
      nixessitycore,
      nixvim,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nixessitycorePkg = nixessitycore.packages.${system}.default;
      in
      {
        formatter = bcfmt.formatter.${system};
        checks = {
          formatting = self.treefmtEval.${system}.config.build.check self;
        };
        devShells = {
          default = pkgs.callPackage ./shell.nix {
            inherit nixvim;
            nixessitycore = nixessitycorePkg;
          };
        };
      }
    );
}
