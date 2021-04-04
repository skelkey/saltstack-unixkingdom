install selinux salt package:
  pkg.installed:
    - pkgs:
      - policycoreutils
      - policycoreutils-python-utils

install m2crypto:
  pkg.installed:
    - name: python3-m2crypto

adding Elastic signing public key:
  file.managed:
    - source: https://artifacts.elastic.co/GPG-KEY-elasticsearch
    - source_hash: 10e406ba504706f44fbfa57a8daba5cec2678b31c1722e262ebecb5102d07659
    - name: /etc/pki/rpm-gpg/GPG-KEY-elasticsearch
    - mode: 644
    - user: root
    - group: root

adding Elastic repository:
  pkgrepo.managed:
    - name: oss-logstash-7.x
    - humanname: Elastic community repository for 7.x packages
    - enabled: true
    - baseurl: https://artifacts.elastic.co/packages/oss-7.x/yum
    - gpgkey: file:///etc/pki/rpm-gpg/GPG-KEY-elasticsearch
    - gpgcheck: 1

install journalbeat service:
  pkg.installed:
    - name: journalbeat
    - version: '7.12.0'

deploy journalbeat configuration:
  file.managed:
    - name: /etc/journalbeat/journalbeat.yml
    - source: salt://common/journalbeat.yml
    - user: root
    - group: root
    - mode: 600

start and enable journalbeat service:
  service.running:
    - name: journalbeat
    - enable: true 

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
