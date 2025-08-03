{
  pkgs ? import <nixpkgs> { },
  nixvim,
  nixessitycore,
  ...
}:

let
  neovim = nixvim.legacyPackages.${pkgs.system}.makeNixvim {
    extraConfigLuaPost = ''
      require 'nixessity'.setup({ projectsdir = vim.fn.getcwd() .. '/sandbox' })
    '';
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "nixessity";
        src = ./.;
        dependencies = with pkgs.vimPlugins; [
          plenary-nvim
          sqlite-lua
        ];
      })
    ];
  };
  sqliteWrapped = pkgs.symlinkJoin {
    name = "sqlitewrapped";
    paths = [ pkgs.sqlite ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/sqlite3 \
        --add-flags "~/.local/share/nvim/nixessity"
    '';
  };
in
pkgs.mkShell {
  packages = [
    sqliteWrapped
    nixessitycore
    neovim
  ];

  inputsFrom = [ ];

  shellHook = ''
    # fix the 'bash: shopt: progcomp: invalid shell option name` error
    export SHELL=/run/current-system/sw/bin/bash
    export DEBUG_PLENARY=1
  '';
}
