local cmd = require 'nixessity.cmd'
local Nix = {}

--Print the 'nix {targetCmd} --help' documentation
--@param targetCmd string: The nix flake command to print documentation
--@return the 'nix {targetCmd}' documentation
function Nix:help(targetCmd)
  return cmd:execute({ cmd = 'nix', args = { targetCmd, '--help' } })
end

return Nix
