local cmd = require 'nixessity.cmd'
local Nix = {}

--Print the 'nix {targetCmd} --help' documentation
--@param targetCmd string: The nix flake command to print documentation
--@return the 'nix {targetCmd}' documentation
function Nix:help(targetCmd)
  return cmd:execute({ cmd = 'nix', args = { targetCmd, '--help' } })
end

local removeFlakeNixSuffix = function(projects)
  local result = {}
  for _, v in ipairs(projects) do
    table.insert(result, string.sub(v, 1, -11)) --remove the '/flake.nix'
  end
  return result
end

--Get the project folders that contains 'flake.nix'
--@param projectsdir string: The root projects directory
--@return a list of nix projects
function Nix:projects(projectsdir)
  local projects =
    cmd:execute({ cmd = 'find', args = { projectsdir, '-name', 'flake.nix', '-printf', '%P\n' } })
  return removeFlakeNixSuffix(projects)
end

--Build project flake
--@param projectsdir string: The root nix projects directory
--@param project string: The project to build
--@param outputdir string: The build output directory
function Nix:build(projectsdir, project, outputdir)
  local finalOutputdir = outputdir .. '/' .. project
  cmd:execute({ cmd = 'mkdir', args = { '-p', finalOutputdir } })
  return cmd:execute({
    cmd = 'nix',
    args = { 'build', 'path:' .. projectsdir .. '/' .. project, '-o', finalOutputdir .. '/default' },
  })
end

--Evaluate project flake
--@param project string: The project to eval
function Nix:eval(project)
  return cmd:execute({
    cmd = 'nix',
    args = {
      'eval',
      '--expr',
      '((builtins.getFlake "' .. project .. '").packages.${builtins.currentSystem})',
      '--impure',
    },
  })
end

return Nix
