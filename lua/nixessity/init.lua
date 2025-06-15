local nix = require 'nixessity.nix'
local ui = require 'nixessity.ui'
local uitelescope = require 'nixessity.ui.telescope'
local log = require 'nixessity.log'

local Nixessity = {}

Nixessity.__projectsdir = ''
Nixessity.__outputdir = './.nixessity'

local function assertProjectdirs(projectsdir)
  assert(projectsdir, 'projectsdir should be set')
end

function Nixessity.setup(opts)
  opts = opts or {}
  assertProjectdirs(opts.projectsdir)
  Nixessity.__projectsdir = opts.projectsdir
  Nixessity.__outputdir = opts.outputdir or Nixessity.__outputdir

  vim.api.nvim_create_user_command('Nixhelp', function(args)
    local cmd = args.fargs[1]
    log.debug('Nixhelp ' .. cmd)
    local doc = nix:help(cmd)
    ui:opendoc('nixhelp ' .. cmd .. ' --help', doc)
  end, { desc = 'nix {targetcmd} --help', nargs = 1 })

  vim.api.nvim_create_user_command('Nixbuild', function()
    local projects = nix:projects(Nixessity.__projectsdir)
    uitelescope.openpicker('Nix projects', projects, function(project)
      log.debug('Nixbuild ' .. project)
      nix:build(Nixessity.__projectsdir, project, Nixessity.__outputdir)
    end)
  end, { desc = 'List nix projects' })
end

return Nixessity
