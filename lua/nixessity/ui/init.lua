local log = require 'nixessity.log'

local Ui = {}

Ui.__docbuf = {}

---Open a buffer in a new window
---@param winName string  # New window name
---@param cmd? string # nix command for documentation, if blank it returns 'nix --help`
function Ui:opendoc(winName, cmd)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, winName)
  local win = vim.api.nvim_open_win(buf, true, { split = 'above', win = 0 })
  -- Ui.__docbuf = { buf = buf, win = win }
  if cmd == nil then
    vim.fn.jobstart({ 'nix', '--help' }, { term = true })
  elseif string.match(cmd, '^nix-') or string.match(cmd, '^nixos-rebuild$') then
    vim.fn.jobstart({ cmd, '--help' }, { term = true })
  else
    vim.fn.jobstart({ 'nix', cmd, '--help' }, { term = true })
  end
  vim.cmd('startinsert')
  log.debug('BufferApi: docOpen: ' .. winName .. ' was opened. win: ' .. win .. ' buf: ' .. buf)
end

--Open a input prompt list
--@param list string[]: The list of selections
function Ui:promptlist(list)
  local selections = {}
  for i, v in ipairs(list) do
    table.insert(selections, string.format('%d. %s', i, v))
  end
  local idx = vim.fn.inputlist(selections)
  if idx > #selections then
    error('Invalid project selected!', 0)
  end
  return list[idx]
end

--Open a input prompt
--@param prompt string: The prompt
function Ui:prompt(prompt)
  return vim.fn.input(prompt)
end

function Ui:openprojects() end

return Ui
