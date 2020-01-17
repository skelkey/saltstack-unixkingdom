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
  x509.pem_managed:
<<<<<<< HEAD
    - name: /etc/pki/ca-trust/source/anchors/unixkingdom.pem
    - source: https://vault.unix-kingdom.fr/v1/unixkingdom_ca/ca/pem
    - source_hash: 26406cbef2a75ab495a5a0622713802b400b14a283544d05e17be91e6589439f
=======
    - name: /etc/pki/ca-trust/source/anchors
    - text: {{ pillar['unixkingdom_ca'] }}
>>>>>>> parent of 3cbe3aa... Correcting path for unixkingdom.pem

update ca trustore:
  cmd.run:
    - name: update-ca-trust
    - cwd: /root
    - runas: root
    - shell: /bin/bash
