local nix = require 'nixessity.nix'
local ui = require 'nixessity.ui'
local log = require 'nixessity.log'

local Nixessity = {}

Nixessity.__projectsdir= '';

local function assertProjectdirs(projectsdir)
  assert(projectsdir, 'projectsdir should be set')
end

function Nixessity.setup(opts)
  opts = opts or {}
  assertProjectdirs(opts.projectsdir)

  vim.api.nvim_create_user_command('Nixhelp', function(args)
    local cmd = args.fargs[1]
    log.debug('Nixhelp ' .. cmd)
    local doc = nix:help(cmd)
    ui:opendoc('nixhelp ' .. cmd .. ' --help', doc)
  end, { desc = 'nix {targetcmd} --help', nargs = 1 })
end

return Nixessity
