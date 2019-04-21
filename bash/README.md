Use my shell setup!

## Pre Install

- Required
  - [NeoVIM](https://neovim.io/)
  - [Yarn](https://yarnpkg.com/en/docs/install#mac-stable)
  - [Dependencies for YouCompleteMe vim plugin](https://valloric.github.io/YouCompleteMe/)
  - Shell Programs
    - tmux
    - watch

## Install

- python3 and pip3
- nodejs and npm
- cmake
- pip install neovim

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

## Usage

Find keybindings in [BINDINGS](./BINDINGS.md)

## Notes

### SSH

`ssh-keygen -t rsa` to make ssh key-pair.

`ssh-copy-id user@server` to send public key

Add an entry to `.ssh/config` of the form

```
Host <alias>
	User <user>
	HostName <hostname>
	Port <port>
```

then `ssh <alias>` will use the information from that record.

### RSYNC

```
rsync \
  --exclude '*vscode*' \
  --exclude '*node_modules*' \
  --exclude '*cache*' \
  --exclude '*Library*' \
  -vrzP \
  --port <port> \
  -e ssh \
  <source> \
  <hostname>:<target>
```
