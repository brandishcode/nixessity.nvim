local job = require 'plenary.job'
local log = require 'nixessity.log'

local Cmd = {}

--@class ExecuteOpts
--@field cmd string: the command to execute
--@field args string[]: the arguments for the command
--@field returnError boolean: set true if you want to return error value (only if there is error as well)
--@field cb function: the callback to be called on_exit

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

--Execute a shell command asynchronously and execute a callback function
--@param opts ExecuteOpts: execute options
function Cmd:executeAsync(opts)
  local cmd = opts.cmd
  local args = opts.args
  local cb = opts.cb

  local exe = job:new({
    command = cmd,
    args = args,
    detached = true,
    on_exit = vim.schedule_wrap(function(j, return_val)
      if return_val == 0 then
        cb(vim.fn.json_decode(j:result()))
      else
        log.error('Nixbuild failed with error ' .. return_val)
      end
    end),
  })
  exe:start()
end

return Cmd
