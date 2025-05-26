These are my personal dotfiles that should work on **Debian GNU/Linux** 11+ (bullseye) and **OpenBSD** 7.6+.

Dotfiles for other operating systems:

* **openSUSE Tumbleweed** dotfiles are in `opensuse` branch [right here](https://github.com/Matriks404/dotfiles/tree/opensuse).

# Essential software

For getting full potential of these dotfiles you need to install following packages (using your favourite package manager such as `apt`, `zypper`, `pkg_add` etc.):

* `aptitude` (**Debian GNU/Linux** only, for `a` Bash alias);
* `flatpak` (**Linux** only, for `upgrade-all` Bash function);
* `git` (for `gitd` and `gits` Bash aliases and `clone-dotfiles-repository`, `copy-dotfiles-to-repos-directory`, `git-commit` and `git-push` Bash functions);
* `sudo` (**Linux** only, for `se` Bash alias and `edit-repos` and `upgrade-all` Bash functions);
* `upgrade-system` (**Debian GNU/Linux** only, for `upgrade-all` Bash function);
* `wikipedia2text` (**Linux** only, for `wiki` Bash alias).

# Getting latest version

If getting dotfiles for the first time, run following command in some safe directory (probably not home if you don't want to replace your already configured setup):

```bash
curl https://raw.githubusercontent.com/Matriks404/dotfiles/refs/heads/master/bin/upgrade-dotfiles-bootstrap.sh | sh
```

Otherwise, execute: `get-new-dotfiles` in your bash session (it will execute `bin/upgrade-dotfiles-bootstrap.sh` shell script).

# Files

* `bin/upgrade-all.sh` - both system upgrade and other applications (e.g. flatpak) update script.
* `.bashrc` - generic bash profile configuration file.
* `.bash_aliases` - various useful bash aliases.
* `.bash_functions` - various useful bash functions.
* `.bash_local_aliases` - **LOCAL** bash aliases (not included in the repo, but you can create this file and it will be respected).
* `.bash_local_functions` - **LOCAL** bash functions (see above).
