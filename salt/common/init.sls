{% set dns1_ip = salt['mine.get']('euw2a-prd-unixkingdom-bind-1', 'network.interface_ip')['euw2a-prd-unixkingdom-bind-1'] %}
{% set dns2_ip = salt['mine.get']('euw2a-prd-unixkingdom-bind-2', 'network.interface_ip')['euw2a-prd-unixkingdom-bind-2'] %}
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
