These are my personal **Debian GNU/Linux** 11+ (bullseye and newer) dotfiles.

Dotfiles for other operating systems:

* **openBSD** 7.6+ dotfiles are in `openbsd` branch [right here](https://github.com/Matriks404/dotfiles/tree/openbsd).
* **openSUSE Tumbleweed** dotfiles are in `opensuse` branch [right here](https://github.com/Matriks404/dotfiles/tree/opensuse).

# Essential software

For getting full potential of these dotfiles you need to install following packages (using any **APT** frontend such as `apt`, `pkcon`, `aptitude`, etc.):

* `aptitude` (for `a` Bash alias);
* `flatpak` (for `sysupd` Bash alias);
* `git` (for `gitd` and `gits` Bash aliases and `git-commit` and `git-push` Bash functions);
* `upgrade-system` (for `sysupd` Bash alias);
* `wikipedia2text` (for `wiki` Bash alias).

# Getting latest version

If getting dotfiles for the first time, run following commands in some safe directory (probably not home if you don't want to replace your already configured setup):

```bash
wget https://github.com/Matriks404/dotfiles/archive/refs/heads/debian.zip
unzip debian.zip -x dotfiles-debian/README.md

dotfiles-debian/build/upgrade-dotfiles.sh

rm dotfiles-debian/build/upgrade-dotfiles.sh
rmdir --parents dotfiles-debian/build
rm debian.zip
```

Otherwise, execute: `get-new-dotfiles` in your bash session (it will execute same commands as described above).

# Files

* `.bashrc` - generic bash profile configuration file.
* `.bash_aliases` - various useful bash aliases.
* `.bash_functions` - various useful bash functions.
* `.bash_local_aliases` - **LOCAL** bash aliases (not included in the repo, but you can create this file and it will be respected).
* `.bash_local_functions` - **LOCAL** bash functions (see above).
