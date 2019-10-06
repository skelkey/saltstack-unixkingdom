set selinux permissive:
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

start and enable slapd service:
  service.running:
    - name: slapd
    - enable: true
