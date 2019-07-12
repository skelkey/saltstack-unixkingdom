install bind service:
  pkg.installed:
    - name: bind-chroot

set right on /var/named:
  file.managed:
    - name: /var/named
    - mode: 755
    - replace: false

set right on /var/named/chroot:
  file.managed:
    - name: /var/named/chroot
    - mode: 775
    - replace: false

set right on /var/named/chroot/var:
  file.managed:
    - name: /var/named/chroot/var
    - mode: 775
    - replace: false

set right on /var/named/chroot/var/named:
  file.managed:
    - name: /var/named/chroot/var/named
    - mode: 775
    - replace: false

set right on /var/named/chroot/var/run:
  file.managed:
    - name: /var/named/chroot/var/run
    - mode: 775
    - replace: false

set right on /var/named/chroot/var/run/named/
  file.managed:
    - name: /var/named/chroot/var/run/named
    - mode: 777
    - replace: false

create a symlink to /var/named/chroot:
  file.symlink:
    - name: /var/named/chroot/var/named/chroot
    - target: /var/named/chroot

start and enable bind service:
  service.running:
    - name: named
    - enable: true


