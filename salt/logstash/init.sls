Adding Elastic signing public key:
  file.managed:
    - source: https://artifacts.elastic.co/GPG-KEY-elasticsearch
    - source_hash: 10e406ba504706f44fbfa57a8daba5cec2678b31c1722e262ebecb5102d07659
    - name: /etc/pki/rpm-gpg/GPG-KEY-elasticsearch
    - mode: 644
    - user: root
    - group: root

Adding Elastic repository:
  pkgrepo.managed:
    - name: oss-logstash-7.x
    - humanname: Elastic community repository for 7.x packages
    - enabled: true
    - baseurl: https://artifacts.elastic.co/packages/oss-7.x/yum
    - gpgkey: file:///etc/pki/rpm-gpg/GPG-KEY-elasticsearch
    - gpgcheck: 1

Install logstash service:
  pkg.installed:
    - name: logstash-oss
    - version: '7.11.2'

Deploy logstash configuration:
  file.managed:
    - name: /etc/logstash/conf.d/logstash.conf
    - source: salt://logstash/logstash.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

Start and enable logstash service:
  service.running:
    - name: logstash
    - enable: true
