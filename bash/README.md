Use my shell setup!

- Required
  - [NeoVIM](https://neovim.io/)
  - [Yarn](https://yarnpkg.com/en/docs/install#mac-stable)
  - [Dependencies for YouCompleteMe vim plugin](https://valloric.github.io/YouCompleteMe/)
  - Shell Programs
    - tmux
    - watch

Install:

Go to `.config/.aliasrc` and set `CONF_OS` to the correct value

From this directory run

```bash
./install.sh
```

Follow the instructions at the end of the install, and you're done!

I use the following cronjob to keep these configs up to date:

```
MAILTO=""
*/15 * * * * bash ~/.scripts/dotupdater
```

This works as long as the repository is cloned using SSH, with an appropriate key.

---

Usage:

Find keybindings in [BINDINGS](./BINDINGS.md)
