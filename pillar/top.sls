base:
  '*':
    - common
  '*openvpn*':
    - openvpn
  '*mariadb*':
    - common_keycloak
    - common_webadm
    - mariadb
  '*bind*':
    - bind
  '*ldap*':
    - ldap
  '*webadm*':
    - common_webadm
    - webadm
  '*repository*':
    - common_letsencrypt
    - repository
  '*vault*':
    - common_letsencrypt
    - vault
  '*haproxy*':
    - haproxy
  '*waproxy*':
    - waproxy
  '*radius*':
    - common_radius
    - radius
  '*strongswan*':
    - common_radius
    - common_letsencrypt
