{
  lib,
  mkShell,
  neovim,
  sqlite,
  wrapNeovimUnstable,
  vimPlugins,
  pname,
  symlinkJoin,
  makeWrapper,
  ...
}:

let
  moduleName = (lib.strings.removeSuffix ".nvim" pname);

  # neovim setup
  luaRcContent = with vimPlugins; ''
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
  pluginDeps = with vimPlugins; [
    plenary-nvim
    sqlite-lua
  ];
  plugins =
    with vimPlugins;
    [
      # lazy-nvim by default is needed for easily module reloading
      lazy-nvim
    ]
    ++ pluginDeps;
  neovimWrapped = wrapNeovimUnstable neovim {
    inherit luaRcContent plugins;
  };
  sqliteWrapped = symlinkJoin {
    name = "sqlitewrapped";
    paths = [ sqlite ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/sqlite3 \
        --add-flags "~/.local/share/nvim/nixessity"
    '';
  };
in
mkShell {
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
