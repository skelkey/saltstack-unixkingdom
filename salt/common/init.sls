set system hostname:
  network.system:
    - hostname: {{ grains['id'] }}
    - apply_hostname: True

set root password:
  user.present:
    - name: root
    - password: {{ pillar['root_hash'] }}

install unixkingdom ca:
  x509.pem_managed:
    - name: /etc/pki/ca-trust/source/anchors
    - text: {{ pillar['unixkingdom_ca'] }}

update ca trustore:
  cmd.run:
    - name: update-ca-trust
    - cwd: /root
    - runas: root
    - shell: /bin/bash
