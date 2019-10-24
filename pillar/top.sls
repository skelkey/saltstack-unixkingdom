base:
  '*':
    - common
  '*openvpn*':
    - openvpn
  '*ejbca*':
    - common_ejbca
    - ejbca
  '*mariadb*':
    - common_webadm
    - common_ejbca
    - mariadb
  '*bind*':
    - bind
  '*ldap*':
    - ldap
  '*webadm*':
    - common_webadm
