{
  pkgs ? import <nixpkgs> { },
  ...
}:

let

  pname = "nixessity.nvim";
  moduleName = (pkgs.lib.strings.removeSuffix ".nvim" pname);

  # neovim setup
  luaRcContent = with pkgs.vimPlugins; ''
    local pluginName = '${pname}'
    local moduleName = '${moduleName}'
    local sqlite = '${sqlite-lua}'

    require 'lazy'.setup({
      {
        dir = vim.fn.getcwd(),
        config = function()
          require(moduleName).setup({ projectsdir = vim.fn.getcwd() .. '/sandbox' })
        end,
      },
      {
        dir = sqlite
      }
    })

    vim.g.mapleader = ' '
    vim.keymap.set('n', '<leader>lr', '<cmd>Lazy reload ' .. pluginName .. '<cr>')
  '';
  # a list of nixvim module dependencies
  pluginDeps = with pkgs.vimPlugins; [
    plenary-nvim
    sqlite-lua
  ];
  plugins =
    with pkgs.vimPlugins;
    [
      # lazy-nvim by default is needed for easily module reloading
      lazy-nvim
    ]
    ++ pluginDeps;
  neovimWrapped = pkgs.wrapNeovimUnstable pkgs.neovim {
    inherit luaRcContent plugins;
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
    neovimWrapped
    sqliteWrapped
  ];

  inputsFrom = [ ];

  shellHook = ''
    # fix the 'bash: shopt: progcomp: invalid shell option name` error
    export SHELL=/run/current-system/sw/bin/bash
    export DEBUG_PLENARY=1
  '';
}
