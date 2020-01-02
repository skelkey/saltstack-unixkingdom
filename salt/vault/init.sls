Adding unix-kingdom repository:
  pkgrepo.managed:
    - name: unixkingdom
    - enabled: true
    - humanname: unix-kingdom repository
    - baseurl: https://repository.unix-kingdom.fr/repos/fedora/$releasever/$basearch
    - gpgkey: https://repository.unix-kingdom.fr/RPM-GPG-KEY-unixkingdom
    - gpgcheck: 1
