{
  lib,
  mkShell,
  neovim,
  wrapNeovimUnstable,
  vimPlugins,
  replaceVars,
  pname,
  ...
}:

let
  moduleName = (lib.strings.removeSuffix ".nvim" pname);

  # neovim setup
  luaRcContent = builtins.readFile (
    replaceVars ./config.lua {
      inherit moduleName pname;
    }
  );
  # a list of nixvim module dependencies
  pluginDeps = with vimPlugins; [ plenary-nvim ];
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
in
mkShell {
  packages = [
    neovimWrapped
  ];

  inputsFrom = [ ];

  shellHook = ''
    # fix the 'bash: shopt: progcomp: invalid shell option name` error
    export SHELL=/run/current-system/sw/bin/bash
  '';
}
