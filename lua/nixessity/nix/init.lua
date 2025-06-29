local cmd = require 'nixessity.cmd'

local Nix = {}

---Get the project folders that contains 'flake.nix'
---@param projectsdir string # The root projects directory
---@return string[] # a list of nix projects
function Nix:projects(projectsdir)
  local res =
    cmd:execute({ cmd = 'find', args = { projectsdir, '-name', 'flake.nix', '-printf', '%P\n' } })
  local projects = {}
  for _, v in ipairs(res) do
    table.insert(projects, string.sub(v, 1, -11)) --remove the '/flake.nix'
  end
  return projects
end

--Build project flake
---@param projectsdir string # The root nix projects directory
---@param project string # The project to build
---@param pkg string # Target package to build
function Nix:build(projectsdir, project, pkg, cb)
  cmd:executeAsync({
    cmd = 'nix',
    args = {
      'build',
      'path:' .. projectsdir .. '/' .. project .. '#' .. pkg,
      '--no-link',
      '--json',
    },
    exitCb = function(res)
      return cb(vim.fn.json_decode(res))
    end,
  })
end

---Evaluate a nix flake
---@param expr string # The nix expression
function Nix:eval(expr)
  local res = cmd:execute({
    cmd = 'nix',
    args = {
      'eval',
      '--expr',
      expr,
      '--impure',
      '--json',
    },
  })
  return vim.fn.json_decode(res)
end

---Verify integrity of a nix store path
---@param storepath string # the nix store path to verify
---@return boolean # true if verification success, otherwise false
function Nix:verifyStorePath(storepath)
  local ok = pcall(cmd.execute, nil, {
    cmd = 'nix',
    args = {
      'store',
      'verify',
      storepath,
      '--quiet',
    },
  })
  if not ok then
    return false
  else
    return true
  end
end

return Nix
