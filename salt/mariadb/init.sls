{% set ejbca_ip = salt['mine.get']('euw2a-prd-unixkingdom-ejbca-1', 'network.interface_ip')['euw2a-prd-unixkingdom-ejbca-1'] %}
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

Create database for EJBCA:
  mysql_database.present:
    - name: 'ejbca'
    - host: localhost
    - character_set: utf8
    - collate: utf8_general_ci
    - connection_user: 'root'
    - connection_pass: {{ pillar['mysql_root_password'] }}
    - connection_charset: utf8
    
Create database user for EJBCA:
  mysql_user.present:
    - host: '{{ ejbca_ip }}'
    - connection_user: 'root'
    - connection_pass: {{ pillar['mysql_root_password'] }}
    - connection_charset: utf8
    - name: 'ejbca'
    - password: {{ pillar['mysql_ejbca_password'] }}

Grant right for database user EJBCA on EJBCA database:
  mysql_grants.present:
    - host: '{{ ejbca_ip }}'
    - connection_user: 'root'
    - connection_pass: {{ pillar['mysql_root_password'] }}
    - grant : all privileges
    - database: ejbca.*
    - user: ejbca
    - connection_charset: utf8

Restart MariaDB service:
  module.wait:
    - name: service.restart
    - m_name: mariadb
