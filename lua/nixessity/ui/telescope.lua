local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require 'telescope.config'.values

local UiTelescope = {}

--Open a telescope picker
--@param list string[]: The list of results to display
function UiTelescope.openpicker(title, list)
  local opts = {}
  pickers
    .new(opts, {
      prompt_title = title,
      finder = finders.new_table {
        results = list,
      },
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

return UiTelescope
