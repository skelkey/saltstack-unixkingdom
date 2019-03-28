set system hostname:
  network.system:
    - hostname: {{ grains['id'] }}
    - apply_hostname: True
