local job = require 'plenary.job'

local Cmd = {}

--Execute a shell command
--@type { cmd: string, args: string[] }
--@return the shell command results
function Cmd:execute(opts)
  local cmd = opts.cmd
  local args = opts.args

  local err = ''
  local exe = job:new({
    command = cmd,
    args = args,
    enable_recording = true,
    on_exit = function(j)
      if #j:stderr_result() > 0 then
        err = table.concat(j:stderr_result(), '\n')
      end
    end,
  })

  local res, code = exe:sync()

  if code == 0 then
    return res
  else
    error(err)
  end
end

return Cmd
