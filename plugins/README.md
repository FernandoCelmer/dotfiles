# Plugins

Tool plugins available in this marketplace.

## Categories

| Category | Path | Description |
|---|---|---|
| vim | [vim/](vim/) | Vim editor plugins and configurations |
| zsh | [zsh/](zsh/) | Zsh shell plugins and configurations |
| tmux | [tmux/](tmux/) | Tmux multiplexer plugins and configurations |

## How to install a plugin

Ask Claude to install a plugin from this marketplace:

```
Install the plugin "<name>" from https://github.com/FernandoCelmer/dotfiles
```

Or run the installer directly:

```bash
curl -fsSL https://raw.githubusercontent.com/FernandoCelmer/dotfiles/master/install.sh | bash -s plugin <name>
```

## How to contribute

1. Fork this repository
2. Create a folder for your plugin in the appropriate category
3. Add an `install.sh` and a `plugin.json` metadata file inside it
4. Add the plugin entry to [registry.json](../registry.json)
5. Open a Pull Request

### Plugin structure

```
plugins/<category>/<plugin-name>/
├── plugin.json      # metadata
├── install.sh       # installation script
└── ...              # plugin files
```

### plugin.json format

```json
{
  "name": "plugin-name",
  "description": "What this plugin does",
  "category": "vim",
  "version": "1.0.0",
  "author": "your-github-username",
  "tags": ["tag1", "tag2"]
}
```
