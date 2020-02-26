Set selinux permissive:
  selinux.mode:
    - name: permissive

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

Deploy configuration for rsyslog:
  file.managed:
    - name: /etc/rsyslog.conf
    - source: salt://haproxy/rsyslog.conf
    - user: root
    - group: root
    - mode: 0644

Deploy certificate for haproxy:
  file.managed:
    - name: /etc/haproxy/webadm.pem
    - source: salt://haproxy/webadm.pem
    - user: root
    - group: root
    - mode: 0600
    - template: jinja

Create directory for log socket:
  file.directory:
    - name: /var/lib/haproxy/dev
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

Start and enable rsyslog service:
  service.running:
    - name: haproxy
    - enable: true

Start and enable haproxy service:
  service.running:
    - name: haproxy
    - enable: true
