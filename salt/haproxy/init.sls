Install haproxy:
  pkg.installed:
    - name: haproxy

Install rsylog:
  pkg.installed:
    - name: rsyslog

Deploy configuration for haproxy:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://haproxy/haproxy.cfg
    - user: root
    - group: root
    - mode: 0644
    - template: jinja

Deploy certificate for haproxy:
  file.managed:
    - name: /etc/haproxy/webadm.pem
    - source: salt://haproxy/webadm.pem
    - user: root
    - group: root
    - mode: 0600
    - template: jinja

Start and enable haproxy service:
  service.running:
    - name: haproxy
    - enable: true
