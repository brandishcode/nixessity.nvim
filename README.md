# Nixessity
For all your nix flake command necessities.

> [!WARNING]
> Plugin is still in development.

# Setup
```lua
require"nixessity".setup({ projectsdir = '~/nix/projects' })
```

# Features
|commands|arguments|definitions|
|-|-|-|
|Nixhelp|targetCmd {string}|Print the target nix command documentation|
|Nixbuild|_none_|Build a flake from a list of nix flake projects|

# Roadmap
- Proper documentation viewing
- `nix build` wrapping
