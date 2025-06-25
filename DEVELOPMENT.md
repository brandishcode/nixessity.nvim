# ExpressionBuilder

Creates a nix expression for `nix eval` to evaluate.

Methods:

- [builtins](#builtins)
- [wrap](#wrap)
- [attr](#attr)
- [func](#func)

## builtins

Creates a nix expression using `builtins` functions.
Example:

```lua
local eb = require'nixessity.nix.builder'
local expr = eb.new():builtins('getFlake', { val = '/path/to/my/nix/flake/project', isString = true }):build()
```

The above example will create `builtins.getFlake "/path/to/my/nix/flake/project"`.

## wrap

Wraps a nix expression with parentheses.
Example:

```lua
local eb = require'nixessity.nix.builder'
local expr = eb.new():builtins('isString', { val = 8, isString = false }):wrap():build()
```

The above example will create `(builtins.isString 8)`

## attr

Add attribute accessor to a nix expression.
Example:

```lua
local eb = require'nixessity.nix.builder'
local expr = eb.new():builtins('getFlake', { val = '/path/to/my/nix/flake/project', isString = true }):wrap():attr('x'):build()
```

The above example will create `(builtins.getFlake "/path/to/my/nix/flake/project").x`

## func

Creates a nix function expression.
Example:

```lua
local eb = require'nixessity.nix.builder'
local expr = eb.new():func('myFunction', { val = 23, isString = false }):build()
```

The above example will create `myFunction 23`.

# Nix

Nix command wrappers and/or implementations.

Methods:

- [verifyStorePath](#verifystorepath)

## verifyStorePath

Verify the integrity of the store paths.

Example:

```lua
local nix = require'nixessity.nix'
local result = nix:verifyStorePath("/nix/store/<some-package-path>")
```

The above example will result to `true` or `false`.
