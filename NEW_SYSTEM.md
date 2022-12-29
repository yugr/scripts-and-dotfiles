Instructions for setting up new machines.

# Common OS setup

* disable sounds
  * (Windows) in "Change system sounds" in Settings
  * (Gnome) `dconf write /org/gnome/desktop/sound/event-sounds false` and `dconf write /org/gnome/desktop/sound/input-feedback-sounds false`
* swap CAPS/Ctrl:
  * (Windows) run SwapCtrlCaps.reg
* disable thumbnail previews:
  * (Windows) run ExtendedTime.reg
* get rid of useless preinstalled SW
  * (Ubuntu) "Installed" tab in Ubuntu SW center
  * (Windows) "Programs and Features" in Settings
* mouse highlight
* Vim mode in browser (vimium)

# Additional packages

Install system packages
* gcc g++ gdb clang lld
* make cmake ninja-build
* autoconf automake autogen autopoint libtool
* ctags vim-youcompleteme patch patchutils
* bison flex
* gawk python python-pip python3 python3-pip perl
* git subversion
* wget curl openssh
* screen tmux vim-gtk
* dos2unix manpages bash-completion ascii
* bzip2 zip unzip
* translate-shell (on Cygwin install manually from https://github.com/soimort/translate-shell , see [instructions](https://www.ostechnix.com/use-google-translate-commandline-linux))
* (Cygwin) man-pages-posix man-pages-linux

and Python packages:
```
$ sudo pip3 install virtualenv pylint tox
```

# Git setup

```
$ git config --global user.name 'User Name'
$ git config --global user.email user@server.com
$ git config --global merge.tool vimdiff
$ git config --global merge.conflictstyle diff3
$ git config --global mergetool.prompt false
$ git config --global credential.helper store
```

To reset password
```
$ git config --global --unset user.password
```

# Linux setup

Fix OOM:
```
echo 'vm.oom_kill_allocating_task = 1' | sudo tee -a /etc/sysctl.conf
```

# Cygwin setup

Install packages:
* [apt-cyg](https://github.com/transcode-open/apt-cyg)
* [Sysinternals](https://docs.microsoft.com/en-us/sysinternals)
* chere (for SetupContextMenu.reg)
* rar archiver:
```
wget http://www.rarlab.com/rar/unrarsrc-5.1.7.tar.gz
tar xf unrarsrc-5.1.7.tar.gz
cd unrar
make && make install
```

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

# VirtualBox setup

* Install Guest Additions (need `make`, `gcc` and `perl`)
* Setup clipboard and shared folders in VM settings
* Add your user to vboxsf group:
```
$ sudo adduser $USER vboxsf
```
