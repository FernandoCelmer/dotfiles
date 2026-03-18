# Plugins

Each plugin lives in its own directory and follows the Claude Code plugin format.

## Structure

```
plugins/<plugin-name>/
├── commands/
│   └── <command-name>.md   # Claude Code slash command
└── README.md               # optional
```

## How to add a plugin

1. Create `plugins/<name>/commands/<name>.md`
2. Add the entry to [.claude-plugin/marketplace.json](../.claude-plugin/marketplace.json)
3. Register it in [registry.json](../registry.json)
4. Open a Pull Request

## How to install via Claude Code

Add this marketplace in Claude Code:

```
FernandoCelmer/dotfiles
```

Then install any plugin:

```
/marketplace install plugin <name>
```
