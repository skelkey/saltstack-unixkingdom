Install PHP packages:
  pkg.installed:
    - pkgs:
      - php-intl
      - php-gd
      - php-mysqlnd
      - php-pear
      - php-devel
      - php-mbstring
      - php-fpm
      - php-ldap

Install nginx package:
  pkg.installed:
    - name: nginx

Install passbolt source code:
  archive.extracted:
    - name: /opt/passbolt_api
    - source: https://github.com/passbolt/passbolt_api/archive/v2.13.5.tar.gz
    - source_hash: 9367a328d4592275cf6841ef5ebeee90fb4efafed50b8b97495aa907e7eefc98
    - if_missing: /opt/passbolt_api
    - enforce_toplevel: true
