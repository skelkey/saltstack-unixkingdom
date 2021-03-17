install selinux salt package:
  pkg.installed:
    - pkgs:
      - policycoreutils
      - policycoreutils-python-utils

install m2crypto:
  pkg.installed:
    - name: python3-m2crypto

# FIXME : Condition must disappear when SaltStack upgraded
{% if grains['osrelease'] == '28' %}
set system hostname:
  network.system:
    - hostname: {{ grains['id'] }}
    - apply_hostname: True
{% endif %}
    
{% if grains['osrelease'] == '33' %}
restart network for Fedora 33:
  cmd.run:
    - name: 'nmcli con reload eth0'
{% endif %}

set root password:
  user.present:
    - name: root
    - password: {{ pillar['root_hash'] }}

install unixkingdom ca:
  file.managed:
    - name: /etc/pki/ca-trust/source/anchors/unixkingdom.pem
    - contents_pillar: unixkingdom_ca

update ca trustore:
  cmd.run:
    - name: update-ca-trust
    - cwd: /root
    - runas: root
    - shell: /bin/bash

# FIXME : Condition must disappear when SaltStack upgraded
{% if grains['osrelease'] == '28' %}
Install zabbix agent:
  pkg.installed:
    - name: zabbix-agent
{% endif %}

{% if grains['osrelease'] == '33' %}
Install zabbix agent:
  pkg.installed:
    - name: zabbix-agent
    - version: '1:5.0.9*'
{% endif %}

Configure zabbix-agent:
  file.managed:
    - name: /etc/zabbix_agentd.conf
    - source: salt://common/zabbix_agentd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

Start and enable zabbix-agent service:
  service.running:
    - name: zabbix-agent
    - enable: true
