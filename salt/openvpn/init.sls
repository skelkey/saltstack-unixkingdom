include:
  - letsencrypt-formula

install openvpn server:
  pkg.installed:
    - name: openvpn

configuration of openvpn server:
  file.managed:
    - name: /etc/openvpn/server.conf
    - source: salt://openvpn/server.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

