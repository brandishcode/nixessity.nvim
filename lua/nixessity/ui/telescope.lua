local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require 'telescope.config'.values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local UiTelescope = {}

--Open a telescope picker
--@param title string: The picker title
--@param list string[]: The list of results to display
--@param callback function: The picker actions
function UiTelescope.openpicker(title, list, callback)
  local opts = {}
  pickers
    .new(opts, {
      prompt_title = title,
      finder = finders.new_table {
        results = list,
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          callback(selection[1])
        end)
        return true
      end,
    })
    :find()
end

return UiTelescope
