These are my personal dotfiles that should work on **Debian GNU/Linux** and **OpenBSD 7.6**+.

Dotfiles for other operating systems:

* **openSUSE Tumbleweed** dotfiles are in `opensuse` branch [right here](https://github.com/Matriks404/dotfiles/tree/opensuse).

# Essential software

For getting full potential of these dotfiles you need to install following packages (using your favourite package manaager such as `apt`, `zypper`, `pkg_add` etc.):

* `aptitude` (Debian GNU/Linux only, for `a` Bash alias);
* `flatpak` (Linux only, for `sysupd` Bash alias);
* `git` (for `gitd` and `gits` Bash aliases and `git-commit` and `git-push` Bash functions);
* `upgrade-system` (Debian GNU/Linux only, for `upgrade-all` Bash function);
* `wikipedia2text` (for `wiki` Bash alias).

# Getting latest version

If getting dotfiles for the first time, run following commands in some safe directory (probably not home if you don't want to replace your already configured setup):

```bash
wget https://github.com/Matriks404/dotfiles/archive/refs/heads/master.zip
unzip master.zip -x dotfiles-master/README.md

dotfiles-master/build/upgrade-dotfiles.sh

rm dotfiles-master/build/upgrade-dotfiles.sh
rmdir -p dotfiles-master/build
rm master.zip
```

Otherwise, execute: `get-new-dotfiles` in your bash session (it will execute same commands as described above).

# Files

* `bin/upgrade-all.sh` - both system upgrade and other applications (e.g. flatpak) update script.
* `.bashrc` - generic bash profile configuration file.
* `.bash_aliases` - various useful bash aliases.
* `.bash_functions` - various useful bash functions.
* `.bash_local_aliases` - **LOCAL** bash aliases (not included in the repo, but you can create this file and it will be respected).
* `.bash_local_functions` - **LOCAL** bash functions (see above).
