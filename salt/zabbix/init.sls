Install zabbix agent:
  pkg.installed:
    - name: zabbix-agent

Start and enable zabbix-agent service:
  service.running:
    - name: zabbix-agent
    - enable: true

Install zabbix server:
  pkg.installed:
    - pkgs:
      - zabbix-server
      - zabbix-web
      - mod_ssl

Deploy zabbix configuration:
  file.managed:
    - name: /etc/zabbix_server.conf
    - source: salt://zabbix/zabbix_server.conf
    - user: root
    - group: zabbixsrv
    - mode: 640
    - template: jinja

Configure httpd for ssl:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://zabbix/httpd.conf
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

Deploy zabbix private key:
  file.managed:
    - name: /etc/httpd/server.key
    - user: root
    - group: root
    - mode: 400
    - contents_pillar:
      - zabbix_key

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
