local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require 'telescope.config'.values

local UiTelescope = {}

--Open a telescope picker that contains nix projects
--@param projects string[]: The list of nix projects
function UiTelescope.openprojects(projects)
  local opts = {}
  pickers
    .new(opts, {
      prompt_title = 'Nix projects',
      finder = finders.new_table {
        results = projects,
      },
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

return UiTelescope
