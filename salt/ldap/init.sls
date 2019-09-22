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

Generate SSL private key:
  x509.private_key_managed:
    - name: /opt/slapd/conf/slapd.key
    - bits: 4096
    - user: root
    - group: root
    - mode: 400

Generate SSL csr:
  x509.csr_managed:
    - name: /opt/slapd/conf/slapd.csr
    - private_key: /opt/slapd/conf/slapd.key
    - CN: euw2a-prd-unixkingdom-ldap-1.unix-kingdom.lan
    - C: FR
    - L: Paris

start and enable slapd service:
  service.running:
    - name: slapd
    - enable: true
