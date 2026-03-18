---
name: marketplace
description: Install, list or search skills and plugins from FernandoCelmer's dotfiles marketplace (https://github.com/FernandoCelmer/dotfiles). Use when the user says "install skill", "install plugin", "list marketplace", "search marketplace", or similar.
---

You are helping the user interact with the dotfiles marketplace at https://github.com/FernandoCelmer/dotfiles.

The registry is at:
https://raw.githubusercontent.com/FernandoCelmer/dotfiles/master/registry.json

The raw base URL for files is:
https://raw.githubusercontent.com/FernandoCelmer/dotfiles/master

## Instructions

### List or search
Fetch registry.json and display skills and plugins in a readable table with name, version, description and category.

### Install a skill
1. Fetch registry.json
2. Find the entry where `name` matches
3. Download the file at `<base_url>/<entry.path>`
4. Save it to `~/.claude/commands/<name>.md`
5. Confirm to the user and tell them to start a new Claude Code session to use `/<name>`

Use this bash pattern:
```bash
curl -fsSL https://raw.githubusercontent.com/FernandoCelmer/dotfiles/master/<path> -o ~/.claude/commands/<name>.md
```

### Install a plugin
1. Fetch registry.json
2. Find the entry where `name` matches
3. Download the file at `<base_url>/<entry.install>`
4. Run it with bash

Use this bash pattern:
```bash
curl -fsSL https://raw.githubusercontent.com/FernandoCelmer/dotfiles/master/<install_path> | bash
```

If the user provides no specific action, list available items and ask what they want to install.
