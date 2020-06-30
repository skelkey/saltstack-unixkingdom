Install freeradius service:
  pkg.installed:
    - pkgs:
      - freeradius
      - freeradius-utils
      - freeradius-ldap

Remove PKI management script:
  file.absent:
    - names:
      - /etc/raddb/certs/Makefile
      - /etc/raddb/certs/README
      - /etc/raddb/certs/ca.cnf
      - /etc/raddb/certs/client.cnf
      - /etc/raddb/certs/inner-server.cnf
      - /etc/raddb/certs/passwords.mk
      - /etc/raddb/certs/server.cnf
      - /etc/raddb/certs/xpextensions

Configuration for radius clients:
  file.managed:
    - name: /etc/raddb/clients.conf
    - source: salt://radius/clients.conf
    - user: root
    - group: radiusd
    - mode: 640
    - template: jinja

Creating an empty bootstrap file:
  file.managed:
    - name: /etc/raddb/certs/bootstrap
    - source: salt://radius/bootstrap
    - user: root
    - group: radiusd
    - mode: 640

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

Configure LDAP connector:
  file.managed:
    - name: /etc/raddb/mods-available/ldap
    - source: salt://radius/ldap
    - user: root
    - group: radiusd
    - mode: 640
    - template: jinja

Activate LDAP connector:
  file.symlink:
    - name: /etc/raddb/mods-enabled/ldap
    - target: /etc/raddb/mods-available/ldap

start and enable radius service:
  service.running:
    - name: radiusd
    - enable: true
