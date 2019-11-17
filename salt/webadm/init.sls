#install selinux salt package:
#  pkg.installed:
#    - pkgs:
#      - policycoreutils
#      - policycoreutils-python-utils

#set selinux permissive:
#  selinux.mode:
#    - name: permissive

Install rcdevs GPG key:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-rcdevs
    - source: https://www.rcdevs.com/repos/redhat/RPM-GPG-KEY-rcdevs.pub
    - source_hash: fd61fca7158401ae72d134fc68170c005c11c8971f6d8f97a0c56d72ab8c0c94
    - user: root
    - group: root
    - mode: 644

Install RCDevs repository:
  pkgrepo.managed:
    - name: rcdevs
    - enabled: True
    - humanname: rcdevs
    - baseurl: https://www.rcdevs.com/repos/redhat
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rcdevs
    - protect: 0

Install RCDevs webadm:
  pkg.installed:
    - name: webadm

Create webadm group:
  group.present:
    - name: webadm
    - system: true

Create webadm user:
  user.present:
    - name: webadm
    - gid_from_name: webadm
    - home: /opt/webadm
    - shell: /sbin/nologin
    - system: true

Deploy servers.xml file:
  file.managed:
    - name: /opt/webadm/conf/servers.xml
    - source: salt://webadm/servers.xml
    - user: root
    - group: root
    - mode: 644
    - template: jinja

Deploy webadm.conf file:
  file.managed:
    - name: /opt/webadm/conf/webadm.conf
    - source: salt://webadm/webadm.conf
    - user: root
    - group: root
    - mode: 644

Deploy objects.xml file:
  file.managed:
    - name: /opt/webadm/conf/objects.xml
    - source: salt://webadm/objects.xml
    - user: root
    - group: root
    - mode: 644

Deploy rsignd.conf file:
  file.managed:
    - name: /opt/webadm/conf/rsignd.conf
    - source: salt://webadm/rsignd.conf
    - user: root
    - group: root
    - mode: 644

Deploy webadm.key file:
  file.managed:
    - name: /opt/webadm/pki/webadm.key
    - source: salt://webadm/webadm.key
    - user: root
    - group: root
    - mode: 400
    - template: jinja

Deploy webadm.crt file:
  file.managed:
    - name: /opt/webadm/pki/webadm.crt
    - source: salt://webadm/webadm.crt
    - user: root
    - group: root
    - mode: 644
    - template: jinja

Create systemd service file:
  file.managed:
    - name: /etc/systemd/system/webadm.service
    - source: salt://webadm/webadm.service
    - user: root
    - group: root
    - mode: 0755

start and enable webadm service:
  service.running:
    - name: webadm
    - enable: true
