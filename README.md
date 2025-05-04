These are my personal **openSUSE** Tumbleweed dotfiles.

# Getting just latest version

Run following commands in some safe directory (probably not home if you don't want to replace your already configured setup):

```bash

wget https://github.com/Matriks404/dotfiles/archive/refs/heads/opensuse.zip
unzip -j opensuse.zip dotfiles-opensuse/.bash*
rm opensuse.zip

```

# Getting regularly updated version

Make sure that you have `git` installed, you are in the directory with your repos (such as `~/repos` or whatever you like) and just run:

```bash
git clone https://github.com/Matriks404/dotfiles.git
cd dotfiles
git checkout opensuse
```

If you need to update your local repository, run: `git pull`.

If you need to copy these files to your home directory run: `cp .bash* ~/`.

# Files

* `.bashrc` - generic bash profile configuration file.
* `.bash_aliases` - various useful bash aliases.
* `.bash_functions` - various useful bash functions.
