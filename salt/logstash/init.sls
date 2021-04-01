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

Deploy UnixKingdom CA for logstash:
  file.managed:
    - name: /etc/logstash/ca.crt
    - user: logstash
    - group: root
    - mode: 640
    - contents_pillar:
      - unixkingdom_ca

Start and enable logstash service:
  service.running:
    - name: logstash
    - enable: true
