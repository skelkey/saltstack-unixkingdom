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

Create logging haproxy socket:
  file.touch:
    - name: /var/lib/haproxy/log

Add haproxy logging socket to fstab:
  fstab.present:
    - name: /dev/log
    - fs_file: /var/lib/haproxy/log
    - fs_mntops: bind
    - mount: True
    

Start and enable rsyslog service:
  service.running:
    - name: haproxy
    - enable: true

Start and enable haproxy service:
  service.running:
    - name: haproxy
    - enable: true
