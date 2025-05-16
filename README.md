These are my personal **openBSD** 7.6+ dotfiles.

# Essential software

For getting full potential of these dotfiles you need to install following packages (using `pkg_add` command as `root` user):

* `bash` (for Bash dotfiles);
* `git` (for `gitd` and `gits` Bash aliases and `git-commit` and `git-push` Bash functions);
* `nano` (for `e` and `se` Bash aliases).

# Getting latest version
**NOTE:** If `unzip` is not available on your system, install it using `pkg_add unzip` command as a `root` user before going any further!

If getting dotfiles for the first time, run following commands in some safe directory (probably not home if you don't want to replace your already configured setup):

```bash
wget https://github.com/Matriks404/dotfiles/archive/refs/heads/openbsd.zip
unzip -j openbsd.zip dotfiles-openbsd/.bash*
rm openbsd.zip
```

Otherwise, execute: `get-new-dotfiles` in your bash session (it will execute same commands as described above).

# Files

* `.bashrc` - generic bash profile configuration file.
* `.bash_aliases` - various useful bash aliases.
* `.bash_functions` - various useful bash functions.
* `.bash_local_aliases` - **LOCAL** bash aliases (not included in the repo, but you can create this file and it will be respected).
* `.bash_local_functions` - **LOCAL** bash functions (see above).
