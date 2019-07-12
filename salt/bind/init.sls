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

start and enable bind service:
  service.running:
    - name: named
    - enable: true


