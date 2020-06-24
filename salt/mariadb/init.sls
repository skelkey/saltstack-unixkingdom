{% set webadm_ip = salt['mine.get']('euw2a-prd-unixkingdom-webadm-1', 'network.interface_ip')['euw2a-prd-unixkingdom-webadm-1'] %}
{% set keycloak_ip = salt['mine.get']('euw2a-prd-unixkingdom-keycloak-1', 'network.interface_ip')['euw2a-prd-unixkingdom-keycloak-1'] %}

install MariaDB service:
  pkg.installed:
    - name: mariadb-server

configure MariaDB service:
  file.managed:
    - name: /etc/my.cnf.d/mariadb-server.cnf
    - source: salt://mariadb/mariadb-server.cnf
    - mode: 644
    - user: root
    - group: root

install python2-mysql:
  pkg.installed:
     - name: python2-mysql

start and enable MariaDB service:
  service.running:
    - name: mariadb
    - enable: true

Set password for MariaDB root user:
  mysql_user.present:
    - name: 'root'
    - password: {{ pillar['mysql_root_password'] }}

Remove MariaDB anonymous user:
  mysql_user.absent:
    - name: ''
    - host: localhost
    - connection_user: 'root'
    - connection_pass: {{ pillar['mysql_root_password'] }}
    - connection_charset: utf8

Remove MariaDB test database:
  mysql_database.absent:
    - name: test
    - host: localhost
    - connection_user: 'root'
    - connection_pass: {{ pillar['mysql_root_password'] }}
    - connection_charset: utf8

Disable remote login for MariaDB root user:
  mysql_query.run:
    - database: 'mysql'
    - query: "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    - output: "/tmp/removehostroot.txt"
    - host: localhost
    - connection_user: 'root'
    - connection_pass: {{ pillar['mysql_root_password'] }}
    - connection_charset: utf8

Create database for WebADM:
  mysql_database.present:
    - name: 'webadm'
    - host: localhost
    - character_set: utf8
    - collate: utf8_general_ci
    - connection_user: 'root'
    - connection_pass: {{ pillar['mysql_root_password'] }}
    - connection_charset: utf8

Create database user for WebADM:
  mysql_user.present:
    - host: '{{ webadm_ip }}'
    - connection_user: 'root'
    - connection_pass: {{ pillar['mysql_root_password'] }}
    - connection_charset: utf8
    - name: {{ pillar['mysql_webadm_user'] }}
    - password: {{ pillar['mysql_webadm_password'] }}

Grant right for database user WebADM on WebADM database:
  mysql_grants.present:
    - host: '{{ webadm_ip }}'
    - connection_user: 'root'
    - connection_pass: {{ pillar['mysql_root_password'] }}
    - grant : all privileges
    - database: webadm.*
    - user: webadm
    - connection_charset: utf8

Create database for Keycloak:
  mysql_database.present:
    - name: 'keycloak'
    - host: localhost
    - character_set: utf8
    - collate: utf8_general_ci
    - connection_user: 'root'
    - connection_pass: {{ pillar['mysql_root_password'] }}
    - connection_charset: utf8

Create database user for Keycloak:
  mysql_user.present:
    - host: '{{ keycloak_ip }}'
    - connection_user: 'root'
    - connection_pass: {{ pillar['mysql_root_password'] }}
    - connection_charset: utf8
    - name: {{ pillar['mysql_keycloak_user'] }}
    - password: {{ pillar['mysql_keycloak_password'] }}

Grant right for database user Keycloak on Keycloak database:
  mysql_grants.present:
    - host: '{{ keycloak_ip }}'
    - connection_user: 'root'
    - connection_pass: {{ pillar['mysql_root_password'] }}
    - grant : all privileges
    - database: keycloak.*
    - user: keycloak
    - connection_charset: utf8

Restart MariaDB service:
  module.wait:
    - name: service.restart
    - m_name: mariadb
