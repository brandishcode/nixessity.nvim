local job = require 'plenary.job'

local Cmd = {}

--@class ExecuteOpts
--@field cmd string: the command to execute
--@field args string[]: the arguments for the command
--@field returnError boolean: set true if you want to return error value (only if there is error as well)

--Execute a shell command
--@param opts ExecuteOpts: execute options
--@return the cmd output or error
function Cmd:execute(opts)
  local cmd = opts.cmd
  local args = opts.args
  local returnError = opts.returnError

  local err = {}
  local exe = job:new({
    command = cmd,
    args = args,
    enable_recording = true,
    on_exit = function(j)
      if #j:stderr_result() > 0 then
        err = j:stderr_result()
      end
    end,
  })

  local res, code = exe:sync()

  if returnError then
    return err
  end

  if code == 0 then
    return res
  else
    error(table.concat(err, '\n'))
  end
end

return Cmd
