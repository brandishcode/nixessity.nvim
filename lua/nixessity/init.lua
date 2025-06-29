local nix = require 'nixessity.nix'
local eb = require 'nixessity.nix.builder'
local ui = require 'nixessity.ui'
local log = require 'nixessity.log'
local storage = require 'nixessity.storage'
local cmd = require 'nixessity.cmd'

local Nixessity = {}

Nixessity.__projectsdir = ''

---Nix <command> --help wrapper
---@param command string # The target command
function Nixessity:help(command)
  log.debug('Nixhelp ' .. command)
  ui:opendoc('nixhelp ' .. command .. ' --help', command)
end

---Nix build
function Nixessity:build()
  local projectsdir = Nixessity.__projectsdir
  local projects = nix:projects(projectsdir)
  if #projects <= 0 then
    log.warn('No nix flake projects found!')
    return
  end

  local projectsMod = {}

  for _, v in ipairs(projects) do
    if v == '' then
      table.insert(projectsMod, '<root>')
    else
      table.insert(projectsMod, v)
    end
  end

  local project = ui:promptlist(projectsMod)
  if project then
    local flake = projectsdir .. '/' .. project
    local expr = eb:new()
      :builtins('attrNames', {
        val = eb:new()
          :builtins('getFlake', { val = flake, isString = true })
          :wrap()
          :attr('packages')
          :attr('${builtins.currentSystem}')
          :wrap()
          :build(),
        isString = false,
      })
      :build()
    local pkgs = nix:eval(expr)
    local pkg = ui:promptlist(pkgs)
    log.debug('Nixbuild ' .. expr)
    nix:build(projectsdir, project, pkg, function(derivation)
      local id = derivation[1].outputs.out
      storage:add({ id = id, flake = flake, package = pkg })
      vim.notify('Nixbuild successful ' .. id, vim.log.levels.INFO)
    end)
  end
end

---Nix build list
function Nixessity:build_run()
  local nixbuilds = storage:read()
  local paths = {}
  for _, v in ipairs(nixbuilds) do
    if nix:verifyStorePath(v.id) then
      table.insert(paths, v.id)
    else
      storage:remove(v)
    end
  end
  local item = storage:read({ id = ui:promptlist(paths) })[1]
  log.debug('Nixbuild list ' .. item.id)
  local expr = eb:new()
    :func(eb:new():import('<nixpkgs>'):attr('lib'):attr('getExe'):build(), {
      val = eb:new()
        :builtins('getFlake', { val = item.flake, isString = true })
        :wrap()
        :attr('packages')
        :attr('${builtins.currentSystem}')
        :attr(item.package)
        :build(),
      isString = false,
    })
    :build()
  local command = nix:eval(expr)
  local args = ui:prompt(string.format('Arguments for %s: ', command))
  --- TODO
  cmd:executeAsync({
    cmd = command,
    args = { args },
    stdoutCb = function(data)
      if data ~= nil then
        vim.fn.append(vim.fn.line('$'), data)
      end
    end,
  })
end

--Nix expr wrapper
function Nixessity:eval(expr)
  vim.api.nvim_put(nix:eval(expr), '', false, true)
end

function Nixessity.setup(opts)
  opts = opts or {}
  Nixessity.__projectsdir = opts.projectsdir
  assert(Nixessity.__projectsdir, 'projectsdir should be set')

  storage:init()

  vim.api.nvim_create_user_command('Nixhelp', function(args)
    local command = args.fargs[1]
    Nixessity:help(command)
  end, { desc = 'nix {targetcommand} --help', nargs = 1 })

  vim.api.nvim_create_user_command('Nixbuild', function(args)
    ---@enum nixbuild_args
    local ARGS = {
      run = 'run',
    }
    if args.fargs[1] == ARGS.run then
      Nixessity:build_run()
    elseif not args.fargs[1] then
      Nixessity:build()
    else
      error(string.format('Nixbuild: incorrect argument %s', args.fargs[1]))
    end
  end, { desc = 'List nix projects', nargs = '?' })

  vim.api.nvim_create_user_command('Nixeval', function(args)
    Nixessity:eval(args.args)
  end, { desc = 'nix eval --expr {project} --impure', nargs = 1 })
end

return Nixessity
