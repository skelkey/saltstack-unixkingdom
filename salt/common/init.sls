install selinux salt package:
  pkg.installed:
    - pkgs:
      - policycoreutils
      - policycoreutils-python-utils

install m2crypto:
  pkg.installed:
    - name: python3-m2crypto

# FIXME : Condition must disappear when SaltStack upgraded
set system hostname:
  network.system:
    - hostname: {{ grains['id'] }}
    {% if grains['osrelease'] == '28' %}
    - apply_hostname: True
    {% endif %}
    
{% if grains['osrelease'] >= '30' %}
restart network for Fedora 33:
  cmd.run:
    - name: 'nmcli con reload eth0'
{% endif %}

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
