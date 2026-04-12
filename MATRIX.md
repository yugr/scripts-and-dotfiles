Some notes on deploying Matrix server with calls.

Some relevant materials:
  - [Tuwunel setup docs](https://matrix-construct.github.io/tuwunel/deploying.html)
  - [Synapse setup docs](https://matrix-org.github.io/synapse/develop/setup/installation.html)

You will need to replace these with values for your setup:
  - `SERVER` - address of your server (e.g. `myserver.com`)

I assume that no firewall is installed,
otherwise necessary ports will need to be opened.

# Setup DNS for your server

Can use free 2-nd level DNS e.g. at https://ydns.com

# Setup Tuwunel server

First create a dedicated user:
```
$ sudo adduser --system tuwunel --group --disabled-login --no-create-home
```

Then install tuwunel:
```
$ wget https://github.com/matrix-construct/tuwunel/releases/download/v1.5.1/v1.5.1-release-all-x86_64-v3-linux-gnu-tuwunel.deb
$ sudo dpkg -i v1.5.1-release-all-x86_64-v3-linux-gnu-tuwunel.deb 
```
(check for latest release on Tuwunel site).

Tuwunel systemd service at `/usr/lib/systemd/system/tuwunel.service`
should already be present, otherwise copy config from Tuwunel docs.

Set
```
[global]
server_name = "SERVER"
allow_federation = false
[global.well_known]
client = "https://SERVER"
```
in `/etc/tuwunel/tuwunel.toml`.

Set perms for tuwunel user:
```
$ sudo chown -R root:root /etc/tuwunel
$ sudo chmod -R 755 /etc/tuwunel
$ sudo mkdir -p /var/lib/tuwunel/
$ sudo chown -R tuwunel:tuwunel /var/lib/tuwunel/
$ sudo chmod 700 /var/lib/tuwunel/
```

Now start the service:
```
$ sudo systemctl start tuwunel
```

# Setup reverse proxy

Install caddy:
```
$ sudo apt install caddy
```

Add
```
SERVER {
    reverse_proxy localhost:8008
}
```
in `/etc/caddy/Caddyfile`.

Start service:
```
$ sudo systemctl enable --now caddy
```

Verify that it works:
```
$ curl https://SERVER/_tuwunel/server_version
```

# Add users

Stop service:
```
$ sudo systemctl stop tuwunel
```

Add the first (admin) user:
```
$ sudo -u tuwunel tuwunel --config /etc/tuwunel/tuwunel.toml --execute "users create_user @ADMIN_USER_NAME:SERVER ADMIN_USER_PASSWORD"
```
(replace `ADMIN_USER_NAME` and `ADMIN_USER_PASSWORD`).

Then start the service
```
$ sudo systemctl start tuwunel
```

You should now be able to login from clients and addnew users in it
in admin chat via
```
!admin users create-user NAME PASSWORD
```
(replace `NAME` and `PASSWORD`).

# Install coturn

Install docker (per https://docs.docker.com/engine/install/ubuntu/).

Install Turn and enable it in Tuwunel config as explained in
https://matrix-construct.github.io/tuwunel/turn.html .
In particular add:
```
turn_uris = [
#    "turns:SERVER?transport=udp",
#    "turns:SERVER?transport=tcp",
    "turn:SERVER?transport=udp",
    "turn:SERVER?transport=tcp"
]
```

Run coturn:
```
$ sudo docker run -d --network=host -v $(pwd)/coturn.conf:/etc/coturn/turnserver.conf coturn/coturn
```

Restart tuwunel
```
$ sudo systemctl restart tuwunel
```

Verify that it works:
```
$ curl https://SERVER/_matrix/client/v3/voip/turnServer
```

# Setup Element Call

TODO

# Android clients

Most modern chats support only Element Call calls
which are not (yet) covered here.

FluffyChat does not seem to support calls
([#1313](https://github.com/krille-chan/fluffychat/issues/1313)).

Shildi Legacy (not Next) and Element Classic seem to call fine.
