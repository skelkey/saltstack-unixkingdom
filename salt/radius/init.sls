Install freeradius service:
  pkg.installed:
    - pkgs:
      - freeradius
      - freeradius-utils
      - freeradius-ldap

#Create radiusd group:
#  group.present:
#    - name: radiusd
#    - system: true

#Create radiusd user:
#  user.present:
#    - name: radiusd
#    - gid_from_name: radiusd
#    - home: /opt/radiusd
#    - shell: /sbin/nologin
#    - system: true

#Configuration for radius clients:
#  file.managed:
#    - name: /opt/radiusd/conf/clients.conf
#    - source: salt://radius/clients.conf
#    - user: root
#    - group: root
#    - mode: 644
#    - template: jinja

#Configure radiusd:
#  file.managed:
#    - name: /opt/radiusd/conf/radiusd.conf
#    - source: salt://radius/radiusd.conf
#    - user: root
#    - group: root
#    - mode: 644

#Set radius certificate:
#  file.managed:
#    - name: /opt/radiusd/conf/radiusd.crt
#    - source: salt://radius/radiusd.crt
#    - user: radiusd
#    - group: radiusd
#    - mode: 644
#    - template: jinja

#Set radius private key:
#  file.managed:
#    - name: /opt/radiusd/conf/radiusd.key
#    - source: salt://radius/radiusd.key
#    - user: radiusd
#    - group: radiusd
#    - mode: 600
#    - template: jinja

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
