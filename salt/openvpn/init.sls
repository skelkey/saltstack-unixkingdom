install cron service:
  pkg.installed:
    - name: cronie

start and enable cronie service:
  service.running:
    - name: crond
    - enable: true

include:
  - letsencrypt

install openvpn server:
  pkg.installed:
    - name: openvpn

generating dh parameter:
  cmd.run:
    - name: openssl dhparam 4096 > /etc/openvpn/server/dhparam.pem
    - unless: test -f /etc/openvpn/server/dhparam.pem

start and enable openvpn service:
  service.running:
    - name: openvpn-server@server
    - enable: true

