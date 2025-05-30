# Dotfiles that you get installed

## Dotfiles lists
These are always included.

* `.dotfiles_lists/common.txt` - list of dotfiles that are always included;
* `.dotfiles_lists/private.txt` - list of dotfiles that are only included if the user is the creator of this GitHub repository;
* `.dotfiles_lists/private_debian.txt` - list of dotfiles that are only included if the user is the creator of this GitHub repository and if on **Debian GNU/Linux** system;

## Common binaries (scripts)
These are always included.

* `.local/bin/update-all.sh` - script that updates all packages (including flatpak ones);
* `.local/bin/upgrade-system.sh` - system upgrade script;

## Common dotfiles
These are always included.

* `.bash_aliases` - various useful bash aliases;
* `.bash_functions` - various useful bash functions;
* `.bash_logout` - set of commands which are executed when you exit **Bash**;
* `.bashrc` - generic bash profile configuration file;
* `.dotfiles_version` - version of dotfiles (you can check it by using included Bash `dotver` function.

## Private dotfiles
These are included only if the user is the creator of this GitHub repository.

* `.gitconfig` - git configuration file.

## Private Debian dotfiles
These are included only if the user is the creator of this GitHub repository and if on **Debian GNU/Linux** system.

* `.reportbugrc` - configuration file for `reportbug` utility.

## Local dotfiles
These are not included in the repepository at all, but you can create these and they will be respected.

* `.bash_local_aliases` - **LOCAL** bash aliases;
* `.bash_local_functions` - **LOCAL** bash functions.

## Update files
These are temporily available during upgrade process.

* `build/update-dotfiles.sh` - upgrades all dotfiles and '''Bash''' scripts.

## Other repository files
These are not installed.

* `tools/hooks/pre-commit` - pre-commit hook, that updates.dotfiles_version before doing a `git commit` command;
* `tools/initial_repository_setup.sh` - a setup script that should be executed only once before doing any kind of changes inside a repository;
* `.dotfiles_os_target` - unused OS target file, which might be used in the future;
* `.gitignore` - a list with files which git ignores;
* `README.md` - this file.
