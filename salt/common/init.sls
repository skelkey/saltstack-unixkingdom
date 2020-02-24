install selinux salt package:
  pkg.installed:
    - pkgs:
      - policycoreutils
      - policycoreutils-python-utils

install m2crypto:
  pkg.installed:
    - name: m2crypto

set system hostname:
  network.system:
    - hostname: {{ grains['id'] }}
    - apply_hostname: true

set root password:
  user.present:
    - name: root
    - password: {{ pillar['root_hash'] }}

install unixkingdom ca:
  file.managed:
    - name: /etc/pki/ca-trust/source/anchors/unixkingdom.pem
    - contents_pillar: unixkingdom_ca

update ca trustore:
  cmd.run:
    - name: update-ca-trust
    - cwd: /root
    - runas: root
    - shell: /bin/bash
