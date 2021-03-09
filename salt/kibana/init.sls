Adding OpenDistro repository:
  file.managed:
    - name: /etc/yum.repos.d/opendistroforelasticsearch-artifacts.repo
    - source: https://d3g5vo6xdbdb9a.cloudfront.net/yum/opendistroforelasticsearch-artifacts.repo
    - source_hash: 17bd17d213f4f185f73b9a38253b5149ed5c3f7a8cef3a482676747dd5d146a2
    - user: root
    - group: root
    - mode: 644

Install OpenDistro service:
  pkg.installed:
    - name: opendistroforelasticsearch-kibana
    - version: '1.13.1-1'

Start and enable elasticsearch service:
  service.running:
    - name: elasticsearch
    - enable: true
