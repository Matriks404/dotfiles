These are my personal **openSUSE** Tumbleweed dotfiles.

# Getting latest version

If getting dotfiles for the first time, run following commands in some safe directory (probably not home if you don't want to replace your already configured setup):

```bash
wget https://github.com/Matriks404/dotfiles/archive/refs/heads/opensuse.zip
unzip -j opensuse.zip dotfiles-opensuse/.bash*
rm opensuse.zip
```

Otherwise, execute: `get-new-dotfiles` in your bash session (it will execute same commands as described above).
>>>>>>> debian

# Files

* `.bashrc` - generic bash profile configuration file.
* `.bash_aliases` - various useful bash aliases.
* `.bash_functions` - various useful bash functions.
