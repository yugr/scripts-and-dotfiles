Typical installation instructions for new server.

During all modifications keep current session open and
test from separate window (in case something goes wrong).

# Protections

Install fail2ban:
```
# apt install fail2ban
```
and set
  - `DEFAULT` bantime to 30m
  - `maxretry` to 3

in `/etc/fail2ban/jail.conf` (run `sudo fail2ban-client reload`
if you ever need to update it later).

Change sshd port to some [arbitrary `uint16_t` number](https://www.convertsimple.com/random-port-generator/)
by editing `/etc/ssh/sshd_config`.  If firewall is running,
may need to update its config too e.g. for ufw:
```
$ sudo ufw allow 2222/tcp
```
Finally run
```
# This may work ...
$ sudo systemctl restart sshd.service
# ... but Ubuntu has this
$ sudo systemctl restart ssh
```

# Make non-root user

```
# useradd -ms /bin/bash MYUSER
# passwd MYUSER
# usermod -aG sudo MYUSER
```

All following commands should be done by new user.

# More protections

Install publickey for new user via
```
$ ssh-copy-id MYUSER@MYSERVER
```
(on host machine).

Then [disable password login](https://askubuntu.com/questions/1516262/why-is-50-cloud-init-conf-created)
and root login on server:
```
$ echo -e 'PasswordAuthentication no\nPermitRootLogin no' | sudo tee /etc/ssh/sshd_config.d/00-no-passwords.conf
```
and restart sshd.

# Disable GUI

```
sudo systemctl set-default multi-user
```

# Install packages

Packages for development:
```
$ sudo apt install git gcc g++ lld make cmake ninja-build autoconf automake autogen autopoint libtool vim gawk python3 perl git wget curl screen bzip2 zip unzip
```
