local NixHelp = require 'nixessity.nix.help'
local BufferApi = require 'nixessity.buffer-api'
local Log = require 'nixessity.log'

local Nixessity = {}

function Nixessity.setup(opts)
  opts = opts or {}
  vim.api.nvim_create_user_command('Nixhelp', function(args)
    local cmd = args.fargs[1]
    Log.debug('Nixhelp ' .. cmd)
    local doc = NixHelp:run(cmd)
    BufferApi:docOpen('nixhelp ' .. cmd .. ' --help', doc)
  end, { desc = 'nix {targetcmd} --help', nargs = 1 })
end

return Nixessity
