--Nix expression builder. To use this you have to call the ExpressionBuilder:new() method

local ExpressionBuilder = {}

ExpressionBuilder.__index = ExpressionBuilder
--@type string: The builder accumulator
ExpressionBuilder.__acc = ''

--@class Arg
--@field val string: The argument value
--@field isString boolean: The value is of type string, if set to true the argument will be wrapped in double quotes

--Nix builtins function expression builder
--@param funcname string: The function name
--@vararg Arg[]: The function arguments
function ExpressionBuilder:builtins(funcname, ...)
  local args = { ... }
  local funcargs = ''
  for _, v in ipairs(args) do
    if v.isString then
      funcargs = funcargs .. ' "' .. v.val .. '"'
    else
      funcargs = funcargs .. ' ' .. v.val
    end
  end
  self.__acc = self.__acc .. 'builtins.' .. funcname .. funcargs
  return self
end

--Wrap nix expression with parenthesis
function ExpressionBuilder:wrap()
  self.__acc = '(' .. self.__acc .. ')'
  return self
end

--Get nix expression attribute
--@param attrName string: The attribute name
function ExpressionBuilder:attr(attrName)
  self.__acc = self.__acc .. '.' .. attrName
  return self
end

--Return the built nix expression
function ExpressionBuilder:build()
  return self.__acc
end

--Create new nix expression builder
function ExpressionBuilder:new()
  return setmetatable({}, ExpressionBuilder)
end

return ExpressionBuilder
