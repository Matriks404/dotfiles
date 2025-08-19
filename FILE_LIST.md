# Dotfiles that you get installed

## Dotfiles lists
These are always included and used by various shell scripts.

* `.dotfiles_lists/common.txt` - list of **dotfiles** that are always included;
* `.dotfiles_lists/common_buildonly.txt` - list of **dotfiles** that are always included, but are not copied to the git repository when using `copy-dotfiles-to-repos-directory` Bash function;
* `.dotfiles_lists/debian.txt` list of **dotfiles** that are only included if on **Debian GNU/Linux** system;
* `.dotfiles_lists/linux.txt` list of **dotfiles** that are only included if on **Linux** system;
* `.dotfiles_lists/openbsd.txt` list of **dotfiles** that are only included if on **OpenBSD** system;
* `.dotfiles_lists/os_specific.txt` list of **dotfiles** that are always included, but have specific versions for different systems;
* `.dotfiles_lists/private.txt` - list of **dotfiles** that are only included if the user is the creator of this **GitHub** repository;
* `.dotfiles_lists/private_debian.txt` - list of **dotfiles** that are only included if the user is the creator of this **GitHub** repository and if on **Debian GNU/Linux** system;

## Common binaries (shell scripts)
These are always included.

* `.local/bin/su-update-software.sh` - script that updates all packages and **flatpak** applications/runtimes;
* `.local/bin/su-upgrade-system.sh` - script that upgrades the operating system to the latest version.

## Linux binaries (shell scripts)
These are included only if on **Linux** system.

* `.local/bin/user-update-software.sh` - script that updates all **flatpak** applications/runtimes.

## Common dotfiles
These are always included.

* `.bash_aliases` - various useful **Bash** aliases;
* `.bash_bindings` - various useful **Bash** bindings;
* `.bash_functions` - various useful **Bash** functions;
* `.bash_logout` - set of commands which are executed when you exit **Bash**;
* `.bashrc` - **Bash** profile configuration file;
* `.dotfiles_version` - version of **dotfiles** (you can check it by using included **Bash** `dotver` function.
* `.nanorc` - **Nano** configuration file;
* `.profile` - generic shell profile configuration file that is loaded on login;
* `.shell_aliases` - various useful shell aliases;
* `.shell_functions` - various useful shell functions;
* `.shrc` - generic shell profile configuration file (loaded by `.profile`);

## Debian dotfiles
These are included only if on **Debian GNU/Linux** system.

* `.config/autostart/load-xresources.desktop` - autostart entry that merges Xresources when entering graphical session (neccessary for **Wayland**-based compositors/desktop environments if using **XWayland** aplications);

## OpenBSD dotfiles
These are included only if on **OpenBSD** system.

* `.xsession` - a graphical session startup script that loads `.profile` and opens some applications licke clock and terminal;

## OS-specific dotfiles
These are always included, but with a different version for each operating system.

* `os_specific/.Xdefults.<os name>` - the older X resources configuration file;
* `os_specific/.Xresources.<os name>` - the newer X resources configuration file, which contains useful XTerm/UXterm configuration.

## Private dotfiles
These are included only if the user is the creator of this **GitHub** repository.

* `.gitconfig` - **git** configuration file.

## Private Debian dotfiles
These are included only if the user is the creator of this GitHub repository and if on **Debian GNU/Linux** system.

* `.reportbugrc` - configuration file for `reportbug` utility.

# Local dotfiles
These are not included in the repepository at all, but you can create these and they will be respected.

* `.bash_local_aliases` - **LOCAL** **Bash** aliases;
* `.bash_local_functions` - **LOCAL** **Bash** functions.

# Update files
These are temporily available during upgrade process.

* `build/update.sh` - updates **dotfiles**.

# Other repository files
These are not installed.

* `tools/hooks/pre-commit` - pre-commit hook, that updates `.dotfiles_version` before doing a `git commit` command;
* `tools/initial_repository_setup.sh` - a setup script that should be executed only once after cloning the **git** repository;
* `.dotfiles_os_target` - unused OS target file, which might be used in the future;
* `.gitignore` - a list with files which **git** ignores;
* `FILE_LIST.md` - Markdown-formatted list of files.
* `README.md` - Markdown-formatted **README** file.
