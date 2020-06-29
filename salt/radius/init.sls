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
    - mode: 644
    - template: jinja

Set radius private key:
  file.managed:
    - name: /etc/raddb/certs/server.key
    - source: salt://radius/server.key
    - user: radiusd
    - group: radiusd
    - mode: 600
    - template: jinja

#Install certificate chain for radius:
#  file.managed:
#    - name: /opt/radiusd/conf/ca.crt
#    - source: salt://radius/ca.crt
#    - user: root
#    - group: root
#    - mode: 644
#    - template: jinja

#start and enable radius service:
#  service.running:
#    - name: radiusd
#    - enable: true
