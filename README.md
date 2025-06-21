# Nixessity
For all your nix flake command necessities.

> [!WARNING]
> Plugin is still in development.

# Setup
```lua
require"nixessity".setup({ projectsdir = '~/nix/projects', outputdir = './nixessity' })
```

# Features
|commands|arguments|definitions|
|-|-|-|
|Nixhelp|`build`, `run`, and etc.|Print the target nix command documentation|
|Nixbuild|_none_|Build a package of a nix flake project from a list of nix flake projects|
|Nixeval|nix expression, e.g.: `Nixeval 1 + 3` results to `4`|Evaluate a nix expression|

# Roadmap
- Proper documentation viewing
- `nix build` wrapping

# Development
See [DEVELOPMENT](./DEVELOPMENT.md)
