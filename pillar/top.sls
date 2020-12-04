base:
  '*':
    - common
  '*openvpn*':
    - openvpn
  '*mariadb*':
    - common_webadm
    - mariadb
  '*bind*':
    - bind
  '*ldap*':
    - common_ldap
    - ldap
  '*webadm*':
    - people
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
    - people
    - common_ldap
    - common_radius
    - radius
  '*strongswan*':
    - common_letsencrypt
    - people
  '*bitwarden*':
    - common_smtp
    - bitwarden
