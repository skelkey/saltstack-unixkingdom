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
    - common_certwebadm
    - common_webadm
    - webadm
  '*repository*':
    - common_letsencrypt
    - repository
  '*vault*':
    - common_letsencrypt
    - vault
  '*haproxy*':
    - common_certwebadm
