Create strongswan group:
  group.present:
    - name: strongswan
    - system: true

Create strongswan user:
  user.present:
    - name: strongswan
    - gid_from_name: strongswan
    - home: /var/lib/strongswan
    - shell: /sbin/nologin
    - system: true

Install strongswan service:
  pkg.installed:
    - name: strongswan

Install xl2tpd service:
  pkg.installed:
    - name: xl2tpd

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
    - name: /var/lib/strongswan/.credentials.ini
    - source: salt://strongswan/credentials.ini
    - template: jinja
    - user: strongswan
    - group: strongswan
    - mode: 400

Authorize strongswan to write letsencrypt logsdir:
  file.directory:
    - name: /var/log/letsencrypt
    - user: strongswan
    - group: strongswan

Authorize stronswan to write in letsencrypt confdir:
  file.directory:
    - name: /etc/letsencrypt
    - user: strongswan
    - group: strongswan
    - recurse:
      - user
      - group

Authorize strongswan to write in letsencrypt workdir:
  file.directory:
    - name: /var/lib/letsencrypt
    - user: strongswan
    - group: strongswan

Initialize certificate:
  cmd.run:
    - name: certbot certonly --dns-ovh --dns-ovh-credential ~/.credentials.ini --non-interactive --agree-tos --email edouard.camoin@gmail.com -d vpn.unix-kingdom.fr
    - runas: strongswan
    - shell: /bin/bash
    - cwd: /var/lib/strongswan

Crontab to renew certificate:
  cron.present:
    - name: /usr/bin/certbot renew --post-hook "systemctl restart strongswan"
    - user: strongswan
    - minute: 0
    - hour: '0,12'

Link letsencrypt chain to strongswan cacerts:
  file.symlink:
    - name: /etc/strongswan/ipsec.d/cacerts/ca.crt
    - target: /etc/letsencrypt/live/vpn.unix-kingdom.fr/chain.pem

Link letsencrypt private key to strongswan private key:
  file.symlink:
    - name: /etc/strongswan/ipsec.d/private/vpn.unix-kingdom.fr.key
    - target: /etc/letsencrypt/live/vpn.unix-kingdom.fr/privkey.pem

Link letsencrypt cert to strongswan certs:
  file.symlink:
    - name: /etc/strongswan/ipsec.d/certs/vpn.unix-kingdom.fr.crt
    - target: /etc/letsencrypt/live/vpn.unix-kingdom.fr/cert.pem

Link letsencrypt cert to strongswan acerts:
  file.symlink:
    - name: /etc/strongswan/ipsec.d/acerts/vpn.unix-kingdom.fr.crt
    - target: /etc/letsencrypt/live/vpn.unix-kingdom.fr/cert.pem

Deploy ipsec secrets file:
  file.managed:
    - name: /etc/strongswan/ipsec.secrets
    - source: salt://strongswan/ipsec.secrets
    - user: root
    - group: root
    - mode: 644

Deploy ipsec configuration file:
  file.managed:
    - name: /etc/strongswan/ipsec.conf
    - source: salt://strongswan/ipsec.conf
    - user: root
    - group: root
    - mode: 644

Deploy xl2tpd configuration file:
  file.managed:
    - name: /etc/xl2tpd/xl2tpd.conf
    - source: salt://strongswan/xl2tpd.conf
    - user: root
    - group: root
    - mode: 644

Deploy xl2tpd options file:
  file.managed:
    - name: /etc/xl2tpd/options.xl2tpd
    - source: salt://strongswan/options.xl2tpd
    - user: root
    - group: root
    - mode: 644

Start and enable strongswan:
  service.running:
    - name: strongswan
    - enable: true

Start and enable xl2tpd:
  service.running:
    - name: xl2tpd
    - enable: true
