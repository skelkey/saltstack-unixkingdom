install bind service:
  pkg.installed:
    - name: bind-chroot

set right on /var/named:
  file.directory:
    - name: /var/named
    - dir_mode: 755
    - replace: false

set right on /var/named/chroot:
  file.directory:
    - name: /var/named/chroot
    - dir_mode: 775
    - replace: false

set right on /var/named/chroot/var:
  file.directory:
    - name: /var/named/chroot/var
    - dir_mode: 775
    - replace: false

set right on /var/named/chroot/var/named:
  file.directory:
    - name: /var/named/chroot/var/named
    - dir_mode: 775
    - replace: false

set right on /var/named/chroot/var/run:
  file.directory:
    - name: /var/named/chroot/var/run
    - dir_mode: 775
    - replace: false

set right on /var/named/chroot/var/run/named/:
  file.directory:
    - name: /var/named/chroot/var/run/named
    - dir_mode: 777
    - replace: false

create a symlink to /var/named/chroot:
  file.symlink:
    - name: /var/named/chroot/var/named/chroot
    - target: /var/named/chroot

create /var/named/chroot/etc/named.conf file:
  file.managed:
    - name: /var/named/chroot/etc/named.conf
    - source: salt://bind/named.conf
    - user: root
    - group: named
    - mode: 640

link named.conf in /etc:
  file.symlink:
    - name: /etc/named.conf
    - target: /var/named/chroot/etc/named.conf

create /var/named/chroot/etc/named/conf.local file:
  file.managed:
    - name: /var/named/chroot/etc/named/conf.local
    - source: salt://bind/conf.local
    - user: root
    - group: named
    - mode: 640

link conf.local in /etc/named:
  file.symlink:
    - name: /etc/named/conf.local
    - target: /var/named/chroot/etc/named/conf.local

create /var/named/chroot/var/named/unix-kingom.lan.zone:
  file.managed:
    - name: /var/named/chroot/var/named/unix-kingdom.lan.zone
    - source: salt://bind/unix-kingdom.lan.zone
    - template: jinja
    - user: root
    - group: named
    - mode: 640

link named.empty in chroot:
  file.symlink:
    - name: /var/named/chroot/var/named/named.empty
    - target: /var/named/named.empty

start and enable bind service:
  service.running:
    - name: named-chroot
    - enable: true

reload bind service:
  module.wait:
    - name: service.reload
    - m_name: named-chroot

