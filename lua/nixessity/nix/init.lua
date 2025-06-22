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
--@param pkg string: Target package to build
--@param string: The output path
function Nix:build(projectsdir, project, pkg)
  return table.concat(cmd:execute({
    cmd = 'nix',
    args = {
      'build',
      'path:' .. projectsdir .. '/' .. project .. '#' .. pkg,
      '--print-out-paths',
      '--no-link',
    },
  }))
end

--Evaluate a nix flake
--@param expr string: The nix expression
--@param json boolean: set true if json return is needed
function Nix:eval(expr, json)
  local args = {
    'eval',
    '--expr',
    expr,
    '--impure',
  }

  if json then
    table.insert(args, '--json')
  end

  local result = cmd:execute({
    cmd = 'nix',
    args = args,
  })

  if json then
    result = vim.fn.json_decode(result)
  end

  return result
end

return Nix
