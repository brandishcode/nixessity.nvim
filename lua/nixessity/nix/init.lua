local cmd = require 'nixessity.cmd'
local Nix = {}

--Print the 'nix {targetCmd} --help' documentation
--@param targetCmd string: The nix flake command to print documentation
--@return the 'nix {targetCmd}' documentation
function Nix:help(targetCmd)
  return cmd:execute({ cmd = 'nix', args = { targetCmd, '--help' } })
end

--Get the project folders that contains 'flake.nix'
--@param projectsdir string: The root projects directory
--@return a list of nix projects
function Nix:projects(projectsdir)
  return cmd:execute({ cmd = 'find', args = { projectsdir, '-name', 'flake.nix', '-printf', '%P\n' } })
end

return Nix
