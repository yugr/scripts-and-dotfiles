Instructions for setting up new machines.

# Additional packages

Install system packages
* gcc g++ gdb
* make cmake
* autoconf automake autogen autopoint libtool
* ctags vim-youcompleteme patch patchutils
* bison flex
* gawk python python-pip python3 python3-pip perl
* git subversion
* wget curl openssh screen tmux
* vim-gtk dos2unix manpages bash-completion cron
* bzip2 zip
* ascii
* translate-shell (on Cygwin install manually from https://github.com/soimort/translate-shell , see also https://www.ostechnix.com/use-google-translate-commandline-linux)

and Python packages:
* virtualenv pylint tox

# Cygwin setup

Install packages:
* apt-cyg (see http://bovs.org/post/128/unix-podobnaya-sreda-v-windows)
* [Sysinternals](https://docs.microsoft.com/en-us/sysinternals)
* chere (for SetupContextMenu.reg)

Also
* run SetupContextMenu.reg (depends on chere)
* (if Windows git is used) copy `/cygdrive/C/Program Files/Git/mingw64/share/git/completion/git-completion.bash` to `/usr/share/bash-completion/completions/git`
* add cron to Windows services:
```
$ cron-config
...
*** Query: Enter the value of CYGWIN for the daemon: [] binmode ntsec
...
```

# Git setup

```
$ git config --global user.name 'User Name'
$ git config --global user.email user@server.com
$ git config merge.tool vimdiff
$ git config merge.conflictstyle diff3
$ git config mergetool.prompt false
```

# OS setup

* disable sounds
  * (Windows) in "Change system sounds" in Settings
  * (Gnome) `dconf write /org/gnome/desktop/sound/event-sounds false` and `dconf write /org/gnome/desktop/sound/input-feedback-sounds false`
* swap CAPS/Ctrl:
  * (Windows) run SwapCtrlCaps.reg
* mouse highlight
* Vim mode in browser
