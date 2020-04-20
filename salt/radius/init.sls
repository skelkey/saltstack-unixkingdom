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

Install RCDevs radius bridge:
  pkg.installed:
    - name: radiusd

Create radiusd group:
  group.present:
    - name: radiusd
    - system: true

Create radiusd user:
  user.present:
    - name: radiusd
    - gid_from_name: radiusd
    - home: /opt/radiusd
    - shell: /sbin/nologin
    - system: true

Configure radiusd:
  file.managed:
    - name: /opt/radiusd/conf/radiusd.conf
    - source: salt://radius/radiusd.conf
    - user: root
    - group: root
    - mode: 644

Set radius certificate:
  file.managed:
    - name: /opt/radiusd/conf/radiusd.crt
    - source: salt://radius/radiusd.crt
    - user: radiusd
    - group: radiusd
    - mode: 644
    - template: jinja

Set radius private key:
  file.managed:
    - name: /opt/radiusd/conf/radiusd.key
    - source: salt://radius/radiusd.key
    - user: radiusd
    - group: radiusd
    - mode: 600
    - template: jinja

Install certificate chain for radius:
  file.managed:
    - name: /opt/radiusd/conf/ca.crt
    - source: salt://radius/ca.crt
    - user: root
    - group: root
    - mode: 644
    - template: jinja

start and enable radius service:
  service.running:
    - name: radiusd
    - enable: true
