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

For Cygwin also install:
* apt-cyg (see http://bovs.org/post/128/unix-podobnaya-sreda-v-windows)
* Sysinternals (https://docs.microsoft.com/en-us/sysinternals)
* chere and run SetupContextMenu.reg
* (if Windows git is used) copy `/cygdrive/C/Program Files/Git/mingw64/share/git/completion/git-completion.bash` to `/usr/share/bash-completion/completions/git`

Python packages:
* virtualenv pylint tox

Setup git:
```
$ git config --global user.name 'User Name'
$ git config --global user.email user@server.com
```

On Cygwin add cron to Windows services:
```
$ cron-config
...
*** Query: Enter the value of CYGWIN for the daemon: [] binmode ntsec
...
```

Other packages:
* https://github.com/vigneshwaranr/bd
* https://www.ostechnix.com/use-google-translate-commandline-linux/
