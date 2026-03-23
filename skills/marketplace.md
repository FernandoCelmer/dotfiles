---
name: marketplace
description: Install, list or search skills from FernandoCelmer's skills marketplace (https://github.com/FernandoCelmer/skills). Use when the user says "install skill", "list marketplace", "search marketplace", or similar.
---

You are helping the user interact with the skills marketplace at https://github.com/FernandoCelmer/skills.

The registry is at:
https://raw.githubusercontent.com/FernandoCelmer/skills/master/registry.json

## Instructions

### List or search
Fetch registry.json and display skills in a readable table with name, version, description and category.

### Install a skill
1. Fetch registry.json
2. Find the entry where `name` matches
3. Use `entry.url` to download the file
4. Save it to `~/.claude/commands/<name>.md`
5. Confirm to the user and tell them to start a new Claude Code session to use `/<name>`

Use this bash pattern:
```bash
curl -fsSL <entry.url> -o ~/.claude/commands/<name>.md
```

If the user provides no specific action, list available skills and ask what they want to install.
