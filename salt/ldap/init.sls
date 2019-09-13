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

start and enable slapd service:
  service.running:
    - name: slapd
    - enable: true
