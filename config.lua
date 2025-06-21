local pluginName = '@pname@'
local moduleName = '@moduleName@'

require 'lazy'.setup({
  {
    dir = vim.fn.getcwd(),
    config = function()
      require(moduleName).setup({ projectsdir = vim.fn.getcwd() .. '/sandbox' })
    end,
  },
})

vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>lr', '<cmd>Lazy reload ' .. pluginName .. '<cr>')
