set selinux permissive:
  selinux.mode:
    - name: permissive

Install strongswan service:
  pkg.installed:
    - name: strongswan

Install iptables:
  pkg.installed:
    - name: iptables

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
    - name: /root/.credentials.ini
    - source: salt://strongswan/credentials.ini
    - template: jinja
    - user: root
    - group: root
    - mode: 400

Initialize certificate:
  cmd.run:
    - name: certbot certonly --dns-ovh --dns-ovh-credential ~/.credentials.ini --non-interactive --agree-tos --email edouard.camoin@gmail.com -d vpn.unix-kingdom.fr

Crontab to renew certificate:
  cron.present:
    - name: /usr/bin/certbot renew --post-hook "systemctl restart strongswan-swanctl"
    - user: root
    - minute: 0
    - hour: '0,12'

Link letsencrypt private key to strongswan private key:
  file.symlink:
    - name: /etc/strongswan/swanctl/private/privkey.pem
    - target: /etc/letsencrypt/live/vpn.unix-kingdom.fr/privkey.pem

Link letsencrypt fullchain to strongswan certs:
  file.symlink:
    - name: /etc/strongswan/swanctl/x509/fullchain.pem
    - target: /etc/letsencrypt/live/vpn.unix-kingdom.fr/fullchain.pem

Deploy unixkingdom CA to strongswan CA:
  file.managed:
    - name: /etc/strongswan/swanctl/x509ca/UnixKingdom_CA.pem
    - mode: 644
    - user: root
    - group: root
    - contents_pillar: unixkingdom_ca

Deploy people unixkingdom CA to strongswan CA:
  file.managed:
    - name: /etc/strongswan/swanctl/x509ca/People_UnixKingdom_CA.pem
    - mode: 644
    - user: root
    - group: root
    - contents_pillar: people_unixkingdom_ca

Deploy swanctl configuration file:
  file.managed:
    - name: /etc/strongswan/swanctl/swanctl.conf
    - source: salt://strongswan/swanctl.conf
    - user: root
    - group: root
    - mode: 640

Deploy strongswan swanctl configuration:
  file.managed:
    - name: /etc/strongswan/strongswan.d/swanctl.conf
    - source: salt://strongswan/strongswan_swanctl.conf
    - user: root
    - group: root
    - mode: 644

Deploy charon systemd configuration:
  file.managed:
    - name: /etc/strongswan/strongswan.d/charon-systemd.conf
    - source: salt://strongswan/charon-systemd.conf
    - user: root
    - group: root
    - mode: 644

Deploy strongswan configuration:
  file.managed:
    - name: /etc/strongswan/strongswan.conf
    - source: salt://strongswan/strongswan.conf
    - user: root
    - group: root
    - mode: 644

Start and enable strongswan-swanctl:
  service.running:
    - name: strongswan-swanctl
    - enable: true
