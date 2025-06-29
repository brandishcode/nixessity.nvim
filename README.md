# Nixessity

For all your nix flake command necessities.

> [!WARNING]
> Plugin is still in development.

# Setup

```lua
require"nixessity".setup({ projectsdir = '~/nix/projects' })
```

# Dependencies

- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [sqlite.lua](https://github.com/kkharji/sqlite.lua)

# Features

<table>
<tbody>
<tr>
<th>commands</th>
<th>arguments</th>
<th>definitions</th>
</tr>
<tr>
<td>Nixhelp</td>
<td><code>build</code>, <code>nix-env</code>, <code>nixos-rebuild</code>, and etc.</td>
<td>Print the target nix command documentation</td>
</tr>
<tr>
<td rowspan="2">Nixbuild</td>
<td><em>none</em></td>
<td>Build a package of a nix flake project from a list of nix flake projects</td>
</tr>
<tr>
<td><code>run</code></td>
<td>Run built packages by nixessity. Selecting a package runs it</td>
</tr>
<tr>
<td>Nixeval</td>
<td>nix expression, e.g.: <code>{ x = 1 + 3; }</code> results to <code>{ x = 4; }</code></td>
<td>Evaluate a nix expression</td>
</tr>
</tbody>
</table>

# Roadmap

- `nix build` wrapping
- `nix eval` wrapping

# Development

See [DEVELOPMENT](./DEVELOPMENT.md)
