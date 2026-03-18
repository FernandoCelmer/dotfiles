---
name: marketplace
description: Install, list or search skills and plugins from FernandoCelmer's dotfiles marketplace (https://github.com/FernandoCelmer/dotfiles). Use when the user says "install skill", "install plugin", "list marketplace", "search marketplace", or similar.
---

You are helping the user interact with the dotfiles marketplace at https://github.com/FernandoCelmer/dotfiles.

The installer script is available at:
https://raw.githubusercontent.com/FernandoCelmer/dotfiles/master/install.sh

The registry is available at:
https://raw.githubusercontent.com/FernandoCelmer/dotfiles/master/registry.json

## Commands

### List everything available
Run:
```bash
curl -fsSL https://raw.githubusercontent.com/FernandoCelmer/dotfiles/master/install.sh | bash -s list
```

### Install a skill
Skills are installed to ~/.claude/commands/<name>.md and become available as /<name> in Claude Code.
```bash
curl -fsSL https://raw.githubusercontent.com/FernandoCelmer/dotfiles/master/install.sh | bash -s skill <name>
```

### Install a plugin
```bash
curl -fsSL https://raw.githubusercontent.com/FernandoCelmer/dotfiles/master/install.sh | bash -s plugin <name>
```

## Instructions

1. If the user asks to **list** or **search**: fetch the registry.json, parse the skills and plugins arrays, and display them in a readable table showing name, version, description and category.

2. If the user asks to **install a skill**: run the install command above with the skill name. Confirm when done and tell the user to start a new Claude Code session to use the new skill.

3. If the user asks to **install a plugin**: run the install command above with the plugin name. Confirm when done.

4. If the user provides no specific action, show the list of available items and ask what they want to install.

Always prefer running the install.sh from the repo if it is locally available at ~/Lab/FernandoCelmer/dotfiles/install.sh.
