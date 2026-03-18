# Skills

Claude Code skills available in this marketplace.

## Categories

| Category | Path | Description |
|---|---|---|
| development | [development/](development/) | Skills for software development workflows |
| git | [git/](git/) | Skills for git operations |
| productivity | [productivity/](productivity/) | Skills for productivity and daily tasks |
| devops | [devops/](devops/) | Skills for DevOps, CI/CD and infrastructure |

## How to install a skill

Ask Claude to install a skill from this marketplace:

```
Install the skill "<name>" from https://github.com/FernandoCelmer/dotfiles
```

Or run the installer directly:

```bash
curl -fsSL https://raw.githubusercontent.com/FernandoCelmer/dotfiles/master/install.sh | bash -s skill <name>
```

## How to contribute

1. Fork this repository
2. Create your skill file in the appropriate category folder
3. Add the skill entry to [registry.json](../registry.json)
4. Open a Pull Request

### Skill file format

```markdown
---
name: skill-name
description: What this skill does (used by Claude to decide when to invoke it)
---

Full prompt/instructions for the skill...
```
