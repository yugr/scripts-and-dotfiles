Instructions for setting up new Linux systems.

Additional packages to install:
* gcc g++ gdb
* make cmake
* autoconf automake autogen autopoint libtool
* ctags patch patchutils
* bison flex
* python python3 python-pip python3-pip perl
* git subversion
* wget curl openssh screen
* vim dos2unix manpages bash-completion cron
* bzip2 zip
* ascii
* (Cygwin only) apt-cyg (see http://bovs.org/post/128/unix-podobnaya-sreda-v-windows)
* (Cygwin only) [Sysinternals](https://docs.microsoft.com/en-us/sysinternals)
* (Cygwin only) chere (for SetupContextMenu.reg)

Python packages:
* virtualenv pylint tox

Other packages:
* https://github.com/vigneshwaranr/bd
* https://www.ostechnix.com/use-google-translate-commandline-linux/ (https://github.com/soimort/translate-shell)

Setup git:
```
$ git config --global user.name 'User Name'
$ git config --global user.email user@server.com
```

For Cygwin also
* run SetupContextMenu.reg (depends on chere)
* run SwapCtrlCaps.reg
* (if Windows git is used) copy `/cygdrive/C/Program Files/Git/mingw64/share/git/completion/git-completion.bash` to `/usr/share/bash-completion/completions/git`
* add cron to Windows services:
```
$ cron-config
...
*** Query: Enter the value of CYGWIN for the daemon: [] binmode ntsec
...
```

Finally, setup mouse highlight in OS.
