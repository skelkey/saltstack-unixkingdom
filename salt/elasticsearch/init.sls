Adding OpenDistro repository:
  file.managed:
    - name: /etc/yum.repos.d/opendistroforelasticsearch-artifacts.repo
    - source: https://d3g5vo6xdbdb9a.cloudfront.net/yum/opendistroforelasticsearch-artifacts.repo
    - source_hash: 17bd17d213f4f185f73b9a38253b5149ed5c3f7a8cef3a482676747dd5d146a2
    - user: root
    - group: root
    - mode: 644

Install Java 11 Development Kit:
  pkg.installed:
    - name: java-11-openjdk-devel

Install OpenDistro service:
  pkg.installed:
    - name: opendistroforelasticsearch
    - version: '1:1.13.1*'
