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
