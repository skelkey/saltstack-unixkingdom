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
    - mode: 644
    - contents_pillar:
      - elasticsearch_key

Deploy unixkingdom root CA for elasticseach:
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

Remove demo certificate:
  file.absent:
    - /etc/elasticsearch/kirk-key.pem

Remove demo certificate:
  file.absent:
    - /etc/elasticsearch/kirk.pem

Start and enable elasticsearch service:
  service.running:
    - name: elasticsearch
    - enable: true
