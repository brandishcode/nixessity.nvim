{
  description = "Nixessity neovim plugin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    bcfmt.url = "github:brandishcode/brandishcode-formatter";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      bcfmt,
      neovim-nightly-overlay,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        neovim = neovim-nightly-overlay.packages.${system}.default;
      in
      {
        formatter = bcfmt.formatter.${system};
        checks = {
          formatting = self.treefmtEval.${system}.config.build.check self;
        };
        devShells = {
          default = pkgs.callPackage ./shell.nix {
            inherit neovim;
          };
        };
      }
    );
}
