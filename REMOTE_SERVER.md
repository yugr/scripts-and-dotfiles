Typical installation instructions for new server.

# Protections

Install fail2ban:
```
# apt install fail2ban
```
and Set `DEFAULT` bantime to 30m in `/etc/fail2ban/jail.conf`.

# Make non-root user

```
# useradd -ms /bin/bash MYUSER
# passwd MYUSER
# usermod -aG sudo MYUSER
```

All following commands should be done by new user.

# Install packages

Minimal list:
```
$ sudo apt install git gcc g++ make cmake ninja-build autoconf automake autogen autopoint libtool vim gawk python3 perl git wget curl screen bzip2 zip unzip
```
