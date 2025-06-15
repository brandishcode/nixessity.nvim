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
|Nixprojects|_none_|Open a telescope picker listing nix projects from the projects directory|

# Roadmap
- Proper documentation viewing
- `nix build` wrapping
