install haproxy service:
  pkg.installed:
    - name: haproxy

start and enable haproxy service:
  service.running:
    - name: haproxy
    - enable: true

install selinux management packages:
  pkg.installed:
    - pkgs:
      - policycoreutils
      - policycoreutils-python-utils

set selinux policy for haproxy to ANY:
  selinux.boolean:
    - name: haproxy_connect_any
    - value: 1
    - persist: true

install rsyslog service:
  pkg.installed:
    - name: rsyslog

start and enable rsyslogd service:
  service.running:
    - name: rsyslog
    - enable: true

configure rsyslog service for haproxy:
  file.managed:
    - name: /etc/rsyslog.conf
    - source: salt://pkihaproxy/rsyslog.conf
    - mode: 644
    - user: root
    - group: root

restart rsyslog service:
  module.wait:
    - name: service.restart
    - m_name: rsyslog

configure haproxy service:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://pkihaproxy/haproxy.cfg
    - template: jinja
    - mode: 600
    - user: haproxy
    - group: root

restart haproxy service:
  module.wait:
    - name: service.restart
    - m_name: haproxy
