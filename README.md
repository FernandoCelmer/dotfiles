# dotfiles

**English**: With the need to automate processes and execution of scripts, **[LinuxProfile](https://github.com/MyLinuxProfile/linux-profile)** emerged, a project developed in python that aims to create a standard in the chaos of storing information about packages, aliases, scripts, texts and files in a single place, fully customizable from according to the user.

> **Português**: Com a necessidade de automatizar os processos e execução de scripts, surgiu **[LinuxProfile](https://github.com/MyLinuxProfile/linux-profile)**, projeto desenvolvido em python que tem como objetivo criar um padrão no caos do armazenamento de informações de pacotes, alias, scripts, textos e arquivos em um único local, totalmente personalizável de acordo com o usuário.

---

## My Profiles -> [LinuxProfile](https://github.com/linux-profile/linux-profile)

- [profile-archlinux.json](https://github.com/FernandoCelmer/dotfiles/blob/master/profile-archlinux.json)
- [profile-macos.json](https://github.com/FernandoCelmer/dotfiles/blob/master/profile-macos.json)
- [profile-ubuntu.json](https://github.com/FernandoCelmer/dotfiles/blob/master/profile-ubuntu.json)


## Marketplace

A public marketplace for Claude Code skills and tool plugins.

Browse skills in [`skills/`](skills/) and plugins in [`plugins/`](plugins/).

All items are indexed in [`registry.json`](registry.json).

### Install via Claude Code

First install the `marketplace` skill:

```bash
curl -fsSL https://raw.githubusercontent.com/FernandoCelmer/dotfiles/master/skills/marketplace.md -o ~/.claude/commands/marketplace.md
```

Then in any Claude Code session:

```
/marketplace list
/marketplace install skill <name>
/marketplace install plugin <name>
```

> Contributions via Pull Request are welcome.

---

## Commit Style

- ⚙️ FEATURE
- 📝 PEP8
- 📌 ISSUE
- 🪲 BUG
- 📘 DOCS
- 📦 PyPI
- ❤️️ TEST
- ⬆️ CI/CD
- ⚠️ SECURITY

## License

This project is licensed under the terms of the MIT license.
