Install freeradius service:
  pkg.installed:
    - pkgs:
      - freeradius
      - freeradius-utils
      - freeradius-ldap

Configuration for radius clients:
  file.managed:
    - name: /etc/raddb/clients.conf
    - source: salt://radius/clients.conf
    - user: root
    - group: radiusd
    - mode: 640
    - template: jinja

Configure radiusd:
  file.managed:
    - name: /etc/raddb/radiusd.conf
    - source: salt://radius/radiusd.conf
    - user: root
    - group: radiusd
    - mode: 640

Set radius certificate:
  file.managed:
    - name: /etc/raddb/certs/server.pem
    - source: salt://radius/server.pem
    - user: radiusd
    - group: radiusd
    - mode: 600
    - template: jinja

Install certificate chain for radius:
  file.managed:
    - name: /etc/raddb/certs/ca.pem
    - source: salt://radius/ca.pem
    - user: root
    - group: root
    - mode: 644
    - template: jinja

Create dh param if not exist:
  cmd.run:
    - name: openssl dhparam -out /etc/raddb/certs/dh 2048
    - onlyif: test ! -e /etc/raddb/certs/dh

start and enable radius service:
  service.running:
    - name: radiusd
    - enable: true
