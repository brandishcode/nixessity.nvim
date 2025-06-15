local log = require 'nixessity.log'

local Ui = {}

Ui.__docbuf = {}

vim.api.nvim_create_autocmd('BufLeave', {
  callback = function(events)
    if Ui.__docbuf.buf == events.buf then
      vim.api.nvim_buf_delete(events.buf, { force = true, unload = false })
    end
  end,
})

--Open a buffer in a new window
--@param winName string: New window name
--@param contents string[]: Array of lines to set buffer contents
function Ui:opendoc(winName, contents)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, winName)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, contents)
  vim.api.nvim_set_option_value('readonly', true, { buf = buf })
  local win = vim.api.nvim_open_win(buf, true, { split = 'above', win = 0 })
  Ui.__docbuf = { buf = buf, win = win }
  log.debug('BufferApi: docOpen: ' .. winName .. ' was opened. win: ' .. win .. ' buf: ' .. buf)
end

function Ui:openprojects() end

return Ui
