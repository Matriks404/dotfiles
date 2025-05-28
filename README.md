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

**NOTE:** You need to have `curl` installed first!

```bash
curl https://raw.githubusercontent.com/Matriks404/dotfiles/refs/heads/master/.local/bin/upgrade-dotfiles-bootstrap.sh | sh
```

Otherwise, execute: `get-new-dotfiles` in your bash session (it will execute `.local/bin/upgrade-dotfiles-bootstrap.sh` shell script, which itself executes `build/upgrade-dotfiles.sh` **WHICH SHOULD NOT BE EXECUTED MANUALLY**).

# Cloning and setting up repository

In your usual directory where you put clone repositories enter following commands:

```bash
git clone https://github.com/Matriks404/dotfiles.git
cd dotfiles
tools/initial_repository_setup.sh
```

# Files

* `bin/upgrade-all.sh` - both system upgrade and other applications (e.g. flatpak) update script.
* `bin/upgrade-dotfiles-bootstrap.sh` - does some initial work (like downloading and extracting the upgraded version of dotfiles) and then executes temporarily available (for building process) `build/upgrade-dotfiles.sh`, and finishes up cleanup afterwards.
* `build/upgrade-dotfiles.sh` - upgrades all dotfiles and Bash scripts, and then does some cleanup.
* `.bashrc` - generic bash profile configuration file.
* `.bash_aliases` - various useful bash aliases.
* `.bash_functions` - various useful bash functions.
* `.bash_local_aliases` - **LOCAL** bash aliases (not included in the repo, but you can create this file and it will be respected).
* `.bash_local_functions` - **LOCAL** bash functions (see above).
