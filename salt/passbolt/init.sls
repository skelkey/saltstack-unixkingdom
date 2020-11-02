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
      - php-pear-crypt-gpg

Install community mysql:
  pkg.installed:
    - name: community-mysql

Install nginx package:
  pkg.installed:
    - name: nginx

Install passbolt source code:
  archive.extracted:
    - name: /opt/
    - source: https://github.com/passbolt/passbolt_api/archive/v2.13.5.tar.gz
    - source_hash: 9367a328d4592275cf6841ef5ebeee90fb4efafed50b8b97495aa907e7eefc98
    - if_missing: /opt/passbolt_api-2.13.5

Link passbolt directory in /var/www:
  file.symlink:
    - target: /opt/passbolt_api-2.13.5
    - name: /var/www/passbolt_api

Configuration of nginx:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://passbolt/nginx.conf
    - user: root
    - group: root
    - mode: 640

Start and enable php-fpm service:
  service.running:
    - name: php-fpm
    - enable: true

Start and enable nginx service:
  service.running:
   - name: nginx
   - enable: true
