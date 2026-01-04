These are my personal dotfiles that should work on **Debian GNU/Linux** 11+ (bullseye), latest version of **Linux Mint** and **OpenBSD**.

Legacy versions of dotfiles for other operating systems:

* **openSUSE Tumbleweed** - [opensuse branch](https://github.com/Matriks404/dotfiles/tree/opensuse) - commit **f8b2734** as of 2025-05-16 (deprecated and not supported).

For the list of files in the repository [go here](Documentation/FILE_LIST.md) -- **NOTE:** This list is updated only occasionally and might be outdated.

# Prerequirements

Before getting dotfiles, you need to make sure to have all neccessary packages.

## Debian GNU/Linux and other Debian-based Linux distributions (like Ubuntu or Linux Mint)

Execute the following:

```bash
sudo apt install apt-file aptitude bash curl flatpak fonts-hack git lynx rsync sudo unzip upgrade-system wget xterm
```

## OpenBSD:

Execute the following as `root` (you might want to execute `su` first, or add `doas` before following command, if you have it configured):
```ksh
pkg_add bash curl git hack-fonts rsync unzip wget
```

# Getting latest version

If getting dotfiles for the first time, run following command in some safe directory (probably not home if you don't want to replace your already configured setup):

```sh
curl https://raw.githubusercontent.com/Matriks404/dotfiles/refs/heads/master/build/update.sh | sh
```

Otherwise, execute: `get-new-dotfiles` in your bash session (it will actually execute the same `curl` script as noted above).

# Cloning and setting up repository

If you have dotfiles installed, just run the following command within **Bash** shell (this will clone the repository to `$HOME/repos/dotfiles/` directory):

```bash
clone-dotfiles-repository
cd ~/repos/dotfiles
tools/initial_repository_setup.sh
```

Or alternatively, in your usual directory where you put clone repositories enter following commands:

```bash
git clone https://github.com/Matriks404/dotfiles.git
cd dotfiles
tools/initial_repository_setup.sh
```
