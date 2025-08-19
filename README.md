These are my personal dotfiles that should work on **Debian GNU/Linux** 11+ (bullseye) and **OpenBSD** 7.6+.

Dotfiles for other operating systems:

* **openSUSE Tumbleweed** - [opensuse branch](https://github.com/Matriks404/dotfiles/tree/opensuse) - commit **f8b2734** as of 2025-05-16 (deprecated and not supported).

For the list of files in the repository [go here](FILE_LIST.md).

# Essential software

For getting full potential of these dotfiles you need to make sure to have all neccessary packages:

On **Debian GNU/Linux** (and maybe **Ubuntu** and other Debian-based Linux distributions) you need to:

* `aptitude` (**Debian GNU/Linux** only, for `a` Bash alias);
* `bash` (for everything Bash-related);
* `curl` (for `check-dotfiles-update` Bash function and `dotverc` Bash alias);
* `flatpak` (**Linux** only, for `upgrade-all` Bash function);
* `fonts-hack` or `hack-fonts` (for `uxterm` Bash alias);
* `git` (for `gitd` and `gits` Bash aliases and `clone-dotfiles-repository`, `copy-dotfiles-to-repos-directory`, `git-commit` and `git-push` Bash functions);
* `lynx` (**Linux** only, for `wiki` Bash function);
* `rsync` (for `copy-dotofiles-to-repos-directory` and `get-new-dotfiles` Bash functions);
* `sudo` (**Linux** only, for `se` Bash alias and `edit-repos` and `upgrade-all` Bash functions);
* `unzip` (for `get-new-dotfiles` Bash function);
* `upgrade-system` (**Debian GNU/Linux** only, for `upgrade-all` Bash function);
* `wget` (for `get-new-dotfiles` Bash function).

# Getting latest version

If getting dotfiles for the first time, run following command in some safe directory (probably not home if you don't want to replace your already configured setup):

**NOTE:** You need to have `curl`, `rsync`, `unzip` and `wget` installed first!

```bash
curl https://raw.githubusercontent.com/Matriks404/dotfiles/refs/heads/master/build/update.sh | sh
```

Otherwise, execute: `get-new-dotfiles` in your bash session (it will actually execute the same `curl` script as noted above).

# Cloning and setting up repository

In your usual directory where you put clone repositories enter following commands:

```bash
git clone https://github.com/Matriks404/dotfiles.git
cd dotfiles
tools/initial_repository_setup.sh
```
