local pluginName = '@pname@'
local moduleName = '@moduleName@'
local telescope = '@telescope@'

require 'lazy'.setup({
  {
    dir = vim.fn.getcwd(),
    config = function()
      require(moduleName).setup({ projectsdir = vim.fn.getcwd() .. '/sandbox' })
    end,
  },
  {
    dir = telescope,
    config = function()
      require 'telescope'.setup()
    end,
  },
})

vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>lr', '<cmd>Lazy reload ' .. pluginName .. '<cr>')
