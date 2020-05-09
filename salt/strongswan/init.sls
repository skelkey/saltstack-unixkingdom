Create strongswan group:
  group.present:
    - name: strongswan
    - system: true

Create strongswan user:
  user.present:
    - name: strongswan
    - gid_from_name: strongswan
    - home: /
    - shell: /sbin/nologin
    - system: true

Install strongswan service:
  pkg.installed:
    - name: strongswan

Install cronie:
  pkg.installed:
    - name: cronie

Start and enable cronie:
  service.running:
    - name: crond
    - enable: true

Install certbot:
  pkg.installed:
    - pkgs:
      - certbot
      - python3-certbot-dns-ovh

Create OVH credentials:
  file.managed:
    - name: /etc/strongswan/.credentials.ini
    - source: salt://strongswan/credentials.ini
    - template: jinja
    - user: strongswan
    - group: strongswan
    - mode: 400

Authorize vault to write letsencrypt logsdir:
  file.directory:
    - name: /var/log/letsencrypt
    - user: vault
    - group: vault

Authorize vault to write in letsencrypt confdir:
  file.directory:
    - name: /etc/letsencrypt
    - user: vault
    - group: vault
    - recurse:
      - user
      - group

Authorize vault to write in letsencrypt workdir:
  file.directory:
    - name: /var/lib/letsencrypt
    - user: vault

Initialize certificate:
  cmd.run:
    - name: certbot certonly --dns-ovh --dns-ovh-credentials /etc/strongswan/.credentials.ini --non-interactive --agree-tos --email edouard.camoin@gmail.com -d vpn.unix-kingdom.fr
    - runas: strongswan
    - shell: /bin/bash

Crontab to renew certificate:
  cron.present:
    - name: /usr/bin/certbot renew --post-hook "systemctl restart strongswan"
    - user: strongswan
    - minute: 0
    - hour: '0,12'

