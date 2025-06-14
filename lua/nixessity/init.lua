local NixHelp = require 'nixessity.nix.help'

local Nixessity = {}

function Nixessity.setup(opts)
  opts = opts or {}
  vim.api.nvim_create_user_command('Nixhelp', function(args)
    local doc = NixHelp:run(args.fargs[1])
    print(table.concat(doc, '\n'))
  end, { desc = 'nix {targetcmd} --help', nargs = 1 })
end

return Nixessity
