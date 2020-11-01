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
