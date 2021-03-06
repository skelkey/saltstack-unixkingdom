Adding OpenDistro repository:
  file.managed:
    - name: /etc/yum.repos.d/opendistroforelasticsearch-artifacts.repo
    - source: https://d3g5vo6xdbdb9a.cloudfront.net/yum/opendistroforelasticsearch-artifacts.repo
    - source_hash: 17bd17d213f4f185f73b9a38253b5149ed5c3f7a8cef3a482676747dd5d146a2
    - user: root
    - group: root
    - mode: 644

Install chkconfig:
  pkg.installed:
    - name: chkconfig

Install Java 11 Development Kit:
  pkg.installed:
    - name: java-11-openjdk-devel

Install OpenDistro service:
  pkg.installed:
    - name: opendistroforelasticsearch
    - version: '1.13.1-1'

Deploy elasticsearch certificate:
  file.managed:
    - name: /etc/elasticsearch/esnode.pem
    - user: root
    - group: elasticsearch
    - mode: 644
    - contents_pillar:
      - elasticsearch_crt
      - server_unixkingdom_ca
      - unixkingdom_ca

Deploy elasticsearch private key:
  file.managed:
    - name: /etc/elasticsearch/esnode-key.pem
    - user: root
    - group: elasticsearch
    - mode: 640
    - contents_pillar:
      - elasticsearch_key

Deploy unixkingdom root CA for elasticsearch:
  file.managed:
    - name: /etc/elasticsearch/root-ca.pem
    - user: root
    - group: elasticsearch
    - mode: 644
    - contents_pillar:
      - unixkingdom_ca

Deploy configuration for OpenDistro ElasticSearch:
  file.managed:
    - name: /etc/elasticsearch/elasticsearch.yml
    - source: salt://elasticsearch/elasticsearch.yml
    - user: root
    - group: elasticsearch
    - mode: 0660
    - template: jinja

Remove demo certificate key:
  file.absent:
    - name: /etc/elasticsearch/kirk-key.pem

Remove demo certificate:
  file.absent:
    - name: /etc/elasticsearch/kirk.pem

Create elasticsearch admin certificate key:
  file.managed:
    - name: /etc/elasticsearch/elasticsearch-key.pem
    - user: root
    - group: elasticsearch
    - mode: 640
    - contents_pillar:
      - es_admin_key

Create elasticsearch admin certificate:
  file.managed:
    - name: /etc/elasticsearch/elasticsearch-cert.pem
    - user: root
    - group: elasticsearch
    - mode: 640
    - contents_pillar:
      - es_admin_cert
      - people_unixkingdom_ca

Deploy internal user configuration:
  file.managed:
    - name: /usr/share/elasticsearch/plugins/opendistro_security/securityconfig/internal_users.yml
    - source: salt://elasticsearch/internal_users.yml
    - user: root
    - group: elasticsearch
    - mode: 640
    - template: jinja

Deploy authentification configuration:
  file.managed:
    - name: /usr/share/elasticsearch/plugins/opendistro_security/securityconfig/config.yml
    - source: salt://elasticsearch/config.yml
    - user: root
    - group: elasticsearch
    - mode: 640
    - template: jinja

Deploy elasticsearch jvm configuration file:
  file.managed:
    - name: /etc/elasticsearch/jvm.options
    - source: salt://elasticsearch/jvm.options
    - user: root
    - group: elasticsearch
    - mode: 660

Link local truststore in Elastic:
  file.symlink:
    - name: /etc/elasticsearch/cacerts
    - target: /etc/pki/java/cacerts

Apply elasticsearch configuration:
  cmd.run:
    - name: /usr/share/elasticsearch/plugins/opendistro_security/tools/securityadmin.sh -cacert /etc/elasticsearch/root-ca.pem -cert /etc/elasticsearch/elasticsearch-cert.pem -key /etc/elasticsearch/elasticsearch-key.pem -h euw2a-prd-unixkingdom-elasticsearch-1.unix-kingdom.lan -icl -nhnv -cd /usr/share/elasticsearch/plugins/opendistro_security/securityconfig/

Start and enable elasticsearch service:
  service.running:
    - name: elasticsearch
    - enable: true
