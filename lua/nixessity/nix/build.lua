local Job = require 'plenary.job'
local Project = require 'nixessity.project'
local Log = require 'nixessity.log'

local NixBuild = {}

local function nixCmd(args)
  return Job:new({
    command = 'nix',
    args = args,
    on_stdout = function(error, data)
      -- print(error)
    end,
    on_exit = function(j, return_val)
      print('Exit Code: ' .. return_val)
    end,
  })
end

function NixBuild.run(buildOutputDir, buildName)
  local buildArgs = { 'build', 'path:./sandbox', '--out-link' }
  table.insert(buildArgs, Project.buildDir .. '/' .. Project.buildName)
  nixCmd(buildArgs):sync()
end
return NixBuild
