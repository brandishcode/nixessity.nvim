# Nixessity

For all your nix flake command necessities.

> [!WARNING]
> Plugin is still in development.

# Setup

```lua
require"nixessity".setup({ projectsdir = '~/nix/projects', outputdir = './nixessity' })
```

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
<td><code>build</code>, <code>run</code>, and etc.</td>
<td>Print the target nix command documentation</td>
</tr>
<tr>
<td rowspan="2">Nixbuild</td>
<td><em>none</em></td>
<td>Build a package of a nix flake project from a list of nix flake projects</td>
</tr>
<tr>
<td><code>list</code></td>
<td>List built packages by nixessity (this also removes builds no longer in the nix store)</td>
</tr>
<tr>
<td>Nixeval</td>
<td>nix expression, e.g.: <code>{ x = 1 + 3; }</code> results to <code>{ x = 4; }</code></td>
<td>Evaluate a nix expression</td>
</tr>
</tbody>
</table>

# Roadmap

- Proper documentation viewing
- `nix build` wrapping
- `nix eval` wrapping

# Development

See [DEVELOPMENT](./DEVELOPMENT.md)
