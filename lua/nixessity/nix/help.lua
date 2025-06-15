local job = require 'plenary.job'
local NixHelp = {}

--Print the 'nix {targetCmd} --help' documentation
--@param targetCmd string: The nix flake command to print documentation
--@return string
function NixHelp:run(targetCmd)
  local stderrResult = ''
  local nixCmd = job:new({
    command = 'nix',
    args = { targetCmd, '--help' },
    enable_recording = true,
    on_exit = function(j)
      if #j:stderr_result() > 0 then
        stderrResult = table.concat(j:stderr_result(), '\n')
      end
    end,
  })
  local res, code = nixCmd:sync()
  if code == 0 then
    return res
  else
    error(stderrResult)
  end
end

return NixHelp
