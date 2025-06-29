local job = require 'plenary.job'

---Call wrapper to handle errors from plenary.jobs
---@param code integer # the return code
---@param res string[] # the stdout of command
---@param err string[] # the stderr of command
local function call(code, res, err)
  if code == 0 then
    return res
  else
    error(table.concat(err, '\n'))
  end
end

local Cmd = {}

---@class ExecuteOpts
---@field cmd string # the command to execute
---@field args string[] # the arguments for the command
---@field exitCb? fun(result: string[]) # the callback to be called on_exit
---@field stdoutCb? fun(data: string) # the callback to be called on_stdout

---Execute a shell command
---@param opts ExecuteOpts # execute options
---@return table # the cmd output or error
function Cmd:execute(opts)
  local cmd = opts.cmd
  local args = opts.args

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

  return call(code, res, err)
end

---Execute a shell command asynchronously and execute a callback function
---@param opts ExecuteOpts # execute options
function Cmd:executeAsync(opts)
  local cmd = opts.cmd
  local args = opts.args
  local exitCb = opts.exitCb
  local stdoutCb = opts.stdoutCb

  local exe = job:new({
    command = cmd,
    args = args,
    detached = true,
    on_stdout = vim.schedule_wrap(function(_, data)
      if stdoutCb ~= nil then
        stdoutCb(data)
      end
    end),
    on_exit = vim.schedule_wrap(function(j, return_val)
      if exitCb ~= nil then
        exitCb(call(return_val, j:result(), j:stderr_result()))
      end
    end),
  })
  exe:start()
end

return Cmd
