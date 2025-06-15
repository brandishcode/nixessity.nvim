local Log = require 'nixessity.log'

local BufferApi = {}

BufferApi.__docbuf = {}

vim.api.nvim_create_autocmd('BufLeave', {
  callback = function(events)
    if BufferApi.__docbuf.buf == events.buf then
      vim.api.nvim_buf_delete(events.buf, { force = true, unload = false })
    end
  end,
})

--Open a buffer in a new window
--@param winName string: New window name
--@param contents string[]: Array of lines to set buffer contents
function BufferApi:opendoc(winName, contents)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, winName)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, contents)
  vim.api.nvim_set_option_value('readonly', true, { buf = buf })
  local win = vim.api.nvim_open_win(buf, true, { split = 'above', win = 0 })
  BufferApi.__docbuf = { buf = buf, win = win }
  Log.debug('BufferApi: docOpen: ' .. winName .. ' was opened. win: ' .. win .. ' buf: ' .. buf)
end

return BufferApi
