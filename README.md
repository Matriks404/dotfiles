These are my personal **Debian GNU/Linux** 11+ (bullseye and newer) dotfiles.

**openSUSE Tumbleweed** dotfiles are in `opensuse` branch [right here](https://github.com/Matriks404/dotfiles/tree/opensuse).

# Getting latest version

If getting dotfiles for the first time, run following commands in some safe directory (probably not home if you don't want to replace your already configured setup):

```bash
wget https://github.com/Matriks404/dotfiles/archive/refs/heads/debian.zip
unzip -j debian.zip dotfiles-debian/.bash*
rm debian.zip
```

Otherwise, execute: `get-new-dotfiles` in your bash session (it will execute same commands as described above).

# Files

* `.bashrc` - generic bash profile configuration file.
* `.bash_aliases` - various useful bash aliases.
* `.bash_functions` - various useful bash functions.
