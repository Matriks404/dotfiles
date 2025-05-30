These are my personal dotfiles that should work on **Debian GNU/Linux** 11+ (bullseye) and **OpenBSD** 7.6+.

Dotfiles for other operating systems:

* **openSUSE Tumbleweed** dotfiles are in `opensuse` branch [right here](https://github.com/Matriks404/dotfiles/tree/opensuse).

# Essential software

For getting full potential of these dotfiles you need to install following packages (using your favourite package manager such as `apt`, `zypper`, `pkg_add` etc.):

* `aptitude` (**Debian GNU/Linux** only, for `a` Bash alias);
* `curl` (for `check-dotfiles-update` Bash function and `dotverc` Bash alias);
* `flatpak` (**Linux** only, for `upgrade-all` Bash function);
* `git` (for `gitd` and `gits` Bash aliases and `clone-dotfiles-repository`, `copy-dotfiles-to-repos-directory`, `git-commit` and `git-push` Bash functions);
* `sudo` (**Linux** only, for `se` Bash alias and `edit-repos` and `upgrade-all` Bash functions);
* `upgrade-system` (**Debian GNU/Linux** only, for `upgrade-all` Bash function);
* `wikipedia2text` (**Linux** only, for `wiki` Bash alias).

# Getting latest version

If getting dotfiles for the first time, run following command in some safe directory (probably not home if you don't want to replace your already configured setup):

**NOTE:** You need to have `curl` installed first!

```bash
curl --silent https://raw.githubusercontent.com/Matriks404/dotfiles/refs/heads/master/build/update.sh | sh
```

Otherwise, execute: `get-new-dotfiles` in your bash session (it will actually execute the same `curl` script as noted above).

# Cloning and setting up repository

In your usual directory where you put clone repositories enter following commands:

```bash
git clone https://github.com/Matriks404/dotfiles.git
cd dotfiles
tools/initial_repository_setup.sh
```

# Files

## Final dotfiles
* `.dotfiles_lists/common.txt` - list of dotfiles that are always included.
* `.dotfiles_lists/private.txt` - list of dotfiles that are only included if the user is the creator of this repo.
* `.dotfiles_lists/private_debian.txt` - list of dotfiles that are only included if the user is the creator of this repo and if on **Debian GNU/Linux** system.
* `.local/bin/update-all.sh` - script that updates all packages (including flatpak ones).
* `.local/bin/upgrade-system.sh` - system upgrade script.
* `.bash_aliases` - various useful bash aliases.
* `.bash_functions` - various useful bash functions.
* `.bash_logout` - set of commands which are executed when you exit **Bash**.
* `.bashrc` - generic bash profile configuration file.
* `.dotfiles_version` - version of dotfiles (you can check it by using included Bash `dotver` function.
* `.gitconfig` - git configuration file, only included if the user is the creator of this repo.
* `.reportbugrc` - configuration file for `reportbug` command, only included if the user is the creator of this repo and if on **Debian GNU/Linux** system.

## Local dotfiles
* `.bash_local_aliases` - **LOCAL** bash aliases (not included in the repo, but you can create this file and it will be respected).
* `.bash_local_functions` - **LOCAL** bash functions (see above).

## Update files
* `build/update-dotfiles.sh` - upgdates all dotfiles and Bash scripts, and then does some cleanup.

## Other files not normally available
* `tools/hooks/pre-commit` - pre-commit hook, that updates.dotfiles_version before doing a `git commit` command.
* `tools/initial_repository_setup.sh` - a setup script that should be executed only once before doing any kind of changes inside a repository.
* `.dotfiles_os_target` - unused OS target file, which might be used in the future.
* `.gitignore` - a list with files which git ignores.
* `README.md` - this file.
