local nix = require 'nixessity.nix'
local eb = require 'nixessity.nix.builder'
local ui = require 'nixessity.ui'
local uitelescope = require 'nixessity.ui.telescope'
local log = require 'nixessity.log'

local Nixessity = {}

Nixessity.__projectsdir = ''
Nixessity.__outputdir = './.nixessity'

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
  local projects = nix:projects(Nixessity.__projectsdir)
  uitelescope.openpicker('Nix projects', projects, function(project)
    local expr = eb:new()
      :builtins('attrNames', {
        val = eb:new()
          :builtins(
            'getFlake',
            { val = Nixessity.__projectsdir .. '/' .. project, isString = true }
          )
          :wrap()
          :attr('packages')
          :attr('${builtins.currentSystem}')
          :wrap()
          :build(),
        isString = false,
      })
      :build()
    log.debug('Nixbuild ' .. expr)
    local output = vim.fn.json_decode(nix:eval(expr))
    uitelescope.openpicker('Nix flake packages', output, function(pkg)
      nix:build(Nixessity.__projectsdir, project, Nixessity.__outputdir, pkg)
    end)
  end)
end

function Nixessity:eval(project)
  local expr = '((builtins.getFlake "' .. project .. '").packages.${builtins.currentSystem})'
  vim.api.nvim_put(nix:eval(project, expr), '', false, true)
end

function Nixessity.setup(opts)
  opts = opts or {}
  Nixessity.__projectsdir = opts.projectsdir
  assert(Nixessity.__projectsdir, 'projectsdir should be set')
  Nixessity.__outputdir = opts.outputdir or Nixessity.__outputdir

  vim.api.nvim_create_user_command('Nixhelp', function(args)
    local cmd = args.fargs[1]
    Nixessity:help(cmd)
  end, { desc = 'nix {targetcmd} --help', nargs = 1 })

  vim.api.nvim_create_user_command('Nixbuild', function()
    Nixessity:build()
  end, { desc = 'List nix projects' })

  vim.api.nvim_create_user_command('Nixeval', function(args)
    Nixessity:eval(args.fargs[1])
  end, { desc = 'nix eval --expr {project} --impure', nargs = 1 })
end

return Nixessity
