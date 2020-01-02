Adding unix-kingdom signing public key:
  file.managed:
    - source: https://repository.unix-kingdom.fr/RPM-GPG-KEY-unixkingdom
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-unixkingdom
    - mode: 644
    - user: root
    - group: root

Adding unix-kingdom repository:
  pkgrepo.managed:
    - name: unixkingdom
    - enabled: true
    - humanname: unix-kingdom repository
    - baseurl: https://repository.unix-kingdom.fr/repos/fedora/$releasever/$basearch
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-unixkingdom
    - gpgcheck: 1

Install vault:
  pkg.installed:
    - name: vault
    - fromrepo: unixkingdom
