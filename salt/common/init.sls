{% set dns1_ip = salt['mine.get']('euw2a-prd-unixkingdom-bind-1', 'network.interface_ip')['euw2a-prd-unixkingdom-bind-1'] %}
{% set dns2_ip = salt['mine.get']('euw2a-prd-unixkingdom-bind-2', 'network.interface_ip')['euw2a-prd-unixkingdom-bind-2'] %}
set system hostname:
  network.system:
    - hostname: {{ grains['id'] }}
    - apply_hostname: True

set system dns:
  network.managed:
    - name: eth0
    - dns:
      - {{ dns1_ip }}
      - {{ dns2_ip }}
      - 8.8.8.8
      - 8.8.4.4
