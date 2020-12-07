Install mysql-client:
  pkg.installed:
    - name: community-mysql

Install zabbix agent:
  pkg.installed:
    - name: zabbix-agent

Start and enable zabbix-agent service:
  service.running:
    - name: zabbix-agent
    - enable: true

Set selinux boolean httpd_can_network_connect_db:
  selinux.boolean:
    - name: httpd_can_network_connect_db
    - value: true
    - persist: true

Set selinux boolean httpd_can_connect_zabbix:
  selinux.boolean:
    - name: httpd_can_connect_zabbix
    - value: true
    - persist: true

Set selinux boolean zabbix_can_network:
  selinux.boolean:
    - name: zabbix_can_network
    - value: true
    - persist: true

Install zabbix server:
  pkg.installed:
    - pkgs:
      - zabbix-server
      - zabbix-web
      - mod_ssl

Deploy new php.ini configuration:
  file.managed:
    - name: /etc/php.ini
    - source: salt://zabbix/php.ini
    - user: root
    - group: root
    - mode: 644

Deploy zabbix configuration:
  file.managed:
    - name: /etc/zabbix_server.conf
    - source: salt://zabbix/zabbix_server.conf
    - user: root
    - group: zabbixsrv
    - mode: 640
    - template: jinja

Deploy httpd configuration for ssl:
  file.managed:
    - name: /etc/httpd/conf.d/ssl.conf
    - source: salt://zabbix/ssl.conf
    - user: root
    - group: root
    - mode: 644

Deploy zabbix certificate:
  file.managed:
    - name: /etc/httpd/server.crt
    - user: root
    - group: root
    - mode: 640
    - contents_pillar:
      - zabbix_crt
      - server_unixkingdom_ca
      - unixkingdom_ca

Deploy zabbix private key:
  file.managed:
    - name: /etc/httpd/server.key
    - user: root
    - group: root
    - mode: 400
    - contents_pillar:
      - zabbix_key

Remove welcome.conf file:
  file.absent:
    - name: /etc/httpd/conf.d/welcome.conf

Deploy zabbix httpd configuration:
  file.managed:
    - name: /etc/httpd/conf.d/zabbix.conf
    - source: salt://zabbix/zabbix.conf
    - user: root
    - group: root
    - mode: 400

Deploy zabbix database schema.sql:
  mysql_query.run_file:
    - database: zabbix
    - connection_user: {{ pillar['mysql_zabbix_user'] }}
    - connection_pass: {{ pillar['mysql_zabbix_password'] }}
    - output: "/tmp/schema.sql.txt"
    - query_file: "/usr/share/zabbix-mysql/schema.sql"

Deploy zabbix database images.sql:
  mysql_query.run_file:
    - database: zabbix
    - connection_user: {{ pillar['mysql_zabbix_user'] }}
    - connection_pass: {{ pillar['mysql_zabbix_password'] }}
    - output: "/tmp/images.sql.txt"
    - query_file: "/usr/share/zabbix-mysql/images.sql"

Deploy zabbix database data.sql:
  mysql_query.run_file:
    - database: zabbix
    - connection_user: {{ pillar['mysql_zabbix_user'] }}
    - connection_pass: {{ pillar['mysql_zabbix_password'] }}
    - output: "/tmp/data.sql.txt"
    - query_file: "/usr/share/zabbix-mysql/data.sql"

Start and enable zabbix-server service:
  service.running:
    - name: zabbix-server
    - enable: true

Start and enable httpd service:
  service.running:
    - name: httpd
    - enable: true

Start and enable php-fpm:
  service.running:
    - name: php-fpm
    - enable: true
