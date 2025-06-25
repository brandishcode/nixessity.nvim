local nix = require 'nixessity.nix'
local eb = require 'nixessity.nix.builder'
local ui = require 'nixessity.ui'
local log = require 'nixessity.log'
local storage = require 'nixessity.storage'

local Nixessity = {}

Nixessity.__projectsdir = ''

--Nix <cmd> --help wrapper
--@param cmd string: The target command
--@return the help document
function Nixessity:help(cmd)
  log.debug('Nixhelp ' .. cmd)
  local doc = nix:help(cmd)
  ui:opendoc('nixhelp ' .. cmd .. ' --help', doc)
end

--Nix build wrapper
function Nixessity:build()
  local projectsdir = Nixessity.__projectsdir
  local projects = nix:projects(projectsdir)
  local projectsMod = {}

  for _, v in ipairs(projects) do
    if v == '' then
      table.insert(projectsMod, '<root>')
    else
      table.insert(projectsMod, v)
    end
  end

  local project = ui:prompt(projectsMod)
  if project then
    local flake = projectsdir .. '/' .. project
    local expr = eb:new()
      :builtins('attrNames', {
        val = eb:new()
          :builtins('getFlake', { val = flake, isString = true })
          :wrap()
          :attr('packages')
          :attr('${builtins.currentSystem}')
          :wrap()
          :build(),
        isString = false,
      })
      :build()
    local pkgs = nix:eval(expr, true)
    local pkg = ui:prompt(pkgs)
    log.debug('Nixbuild ' .. expr)
    local outputpath = nix:build(projectsdir, project, pkg)
    storage:add({ id = outputpath, flake = flake })
  end
end

--Nix expr wrapper
function Nixessity:eval(expr)
  vim.api.nvim_put(nix:eval(expr), '', false, true)
end

function Nixessity.setup(opts)
  opts = opts or {}
  Nixessity.__projectsdir = opts.projectsdir
  assert(Nixessity.__projectsdir, 'projectsdir should be set')
  Nixessity.__outputdir = opts.outputdir or Nixessity.__outputdir

  storage:init()

  vim.api.nvim_create_user_command('Nixhelp', function(args)
    local cmd = args.fargs[1]
    Nixessity:help(cmd)
  end, { desc = 'nix {targetcmd} --help', nargs = 1 })

  vim.api.nvim_create_user_command('Nixbuild', function(args)
    local cmd = args.fargs[1]
    if not cmd then
      Nixessity:build()
    elseif cmd == 'list' then
      local nixbuilds = storage:read()
      local paths = {}
      for _, v in ipairs(nixbuilds) do
        if nix:verifyStorePath(v.id) then
          table.insert(paths, v.id)
        else
          storage:remove(v)
        end
      end
      ui:prompt(paths)
    end
  end, { desc = 'List nix projects', nargs = '?' })

  vim.api.nvim_create_user_command('Nixeval', function(args)
    Nixessity:eval(args.args)
  end, { desc = 'nix eval --expr {project} --impure', nargs = 1 })
end

return Nixessity
