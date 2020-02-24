Install haproxy:
  pkg.installed:
    - name: haproxy

Deploy configuration for haproxy:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://haproxy/haproxy.cfg
    - user: root
    - group: root
    - mode: 0644
    - template: jinja

Start and enable haproxy service:
  service.running:
    - name: haproxy
    - enable: true
