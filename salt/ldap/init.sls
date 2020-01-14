Install selinux salt package:
  pkg.installed:
    - pkgs:
      - policycoreutils
      - policycoreutils-python-utils


Set selinux permissive:
  selinux.mode:
    - name: permissive

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

Install RCDevs ldap:
  pkg.installed:
    - name: slapd

Install cacert unixkingdom:
  file.managed:
    - name: /opt/slapd/conf/cacert.crt
    - source: salt://ldap/cacert.crt
    - template: jinja
    - user: root
    - group: root
    - mode: 640

Install slapd certificate:
  file.managed:
    - name: /opt/slapd/conf/slapd.crt
    - source: salt://ldap/slapd.crt
    - template: jinja
    - user: root
    - group: root
    - mode: 640

Install slapd private key:
  file.managed:
    - name: /opt/slapd/conf/slapd.key
    - source: salt://ldap/slapd.key
    - template: jinja
    - user: root
    - group: root
    - mode: 400

Configure slapd:
  file.managed:
    - name: /opt/slapd/conf/slapd.conf
    - source: salt://ldap/slapd.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644

Create slapd group:
  group.present:
    - name: slapd
    - gid: 992
    - system: true

Create slapd user:
  user.present:
    - name: slapd
    - gid_from_name: slapd
    - home: /opt/slapd
    - shell: /sbin/nologin
    - system: true

Create systemd service file:
  file.managed:
    - name:  /etc/systemd/system/slapd.service
    - source: salt://ldap/slapd.service
    - user: root
    - group: root
    - mode: 0755

Populate slapd database:
  cmd.run:
    - names:
      - /opt/slapd/libexec/arch-check > /opt/slapd/data/DB_ARCH
      - echo -n "MDB" > /opt/slapd/data/DB_TYPE
      - /opt/slapd/libexec/rcdevs-slapd -T add -l /opt/slapd/lib/treebase.ldif
    - unless: test -f /opt/slapd/data/data.mdb

Set permission on /opt/slapd/conf:
  file.directory:
    - name: /opt/slapd/conf
    - mode: 750
    - user: root
    - group: slapd

Set permission on /opt/slapd/logs:
  file.directory:
    - name: /opt/slapd/logs
    - mode: 770
    - user: root
    - group: slapd

Set permission on /opt/slapd/temp:
  file.directory:
    - name: /opt/slapd/temp
    - mode: 770
    - user: root
    - group: slapd

Set permission on /opt/slapd/data/:
  file.directory:
    - name: /opt/slapd/data
    - mode: 770
    - user: slapd
    - group: slapd
    - recurse:
      - user
      - group

Set permission on /opt/slapd/data:
  file.directory:
    - name: /opt/slapd/data
    - mode: 770
    - user: root
    - group: slapd

Start and enable slapd service:
  service.running:
    - name: slapd
    - enable: true
