local db = require 'sqlite.db'
local tbl = require 'sqlite.tbl'
local uri = vim.fn.stdpath('data') .. '/nixessity'

--[[ Datashapes ---

--@class StorageItem
--@field id: string
--@field flake: string

--]]

local Storage = {}

Storage.__db = nil

--Create a storage for builds
function Storage:init()
  local nixbuild = tbl('nixbuild', {
    id = { type = 'string', required = true, primary = true },
    flake = { type = 'text', required = true },
    package = { type = 'string', required = true },
    timestamp = { 'real', default = db.lib.julianday 'now' },
  })
  local nixdb = db {
    uri = uri,
    nixbuild = nixbuild,
    opts = {
      keep_open = true,
    },
  }
  Storage.__db = nixdb
end

--Add an item to storage
--@param item : Item to be added
--@return true if successfully added
function Storage:add(item)
  Storage:remove(item)
  item.timestamp = db.lib.julianday 'now'
  return Storage.__db.nixbuild:insert {
    id = item.id,
    flake = item.flake,
    package = item.package,
  }
end

--Read the item in storage
--@param item StorageItem|nil: item to be read, if nil read all
--@return StorageItem
function Storage:read(item)
  if item then
    return Storage.__db.nixbuild:get {
      where = {
        id = item.id,
      },
      select = {
        'id',
        'flake',
        'package',
        'timestamp',
      },
    }
  else
    return Storage.__db.nixbuild:get({
      query = { all = 1 },
    })
  end
end

--Remove the item from storage
--@param item StorageItem: item to be removed
function Storage:remove(item)
  Storage.__db.nixbuild:remove { id = item.id }
end

return Storage
