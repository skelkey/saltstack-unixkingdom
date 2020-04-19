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

#Create waproxy group:
#  group.present:
#    - name: waproxy
#    - system: true

#Create waproxy user:
#  user.present:
#    - name: waproxy
#    - gid_from_name: waproxy
#    - home: /opt/waproxy
#    - shell: /sbin/nologin
#    - system: true

#Configure waproxy:
#  file.managed:
#    - name: /opt/waproxy/conf/waproxy.conf
#    - source: salt://waproxy/waproxy.conf
#    - user: root
#    - group: root
#    - mode: 644

#Set waproxy certificate:
#  file.managed:
#    - name: /opt/waproxy/conf/waproxy.crt
#    - source: salt://waproxy/waproxy.crt
#    - user: root
#    - group: root
#    - mode: 644
#    - template: jinja

#Set waproxy private key:
#  file.managed:
#    - name: /opt/waproxy/conf/waproxy.key
#    - source: salt://waproxy/waproxy.key
#    - user: root
#    - group: root
#    - mode: 600
#    - template: jinja

#Install certificate chain for waproxy:
#  file.managed:
#    - name: /opt/waproxy/conf/ca.crt
#    - source: salt://waproxy/ca.crt
#    - user: root
#    - group: root
#    - mode: 644
#    - template: jinja

#start and enable waproxy service:
#  service.running:
#    - name: waproxy
#    - enable: true
