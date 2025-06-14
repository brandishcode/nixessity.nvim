local Job = require 'plenary.job'
local log = require 'plenary.log':new()
log.level = 'debug'
local NixHelp = {}

--Print the 'nix {targetCmd} --help' documentation
--@param targetCmd string: The nix flake command to print documentation
--@return string
function NixHelp:run(targetCmd)
  local doc
  Job:new({
    command = 'nix',
    args = { targetCmd, '--help' },
    on_stdout = function(error, _)
      if error then
        log.debug('Nixhelp ' .. targetCmd .. ' error: ' .. error)
      end
    end,
    on_exit = function(job, return_val)
      log.debug('Nixhelp ' .. targetCmd .. ' return_val: ' .. return_val)
      doc = job:result()
    end,
  }):sync()
  return doc
end

return NixHelp
