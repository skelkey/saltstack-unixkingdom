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

Set selinux boolean httpd_can_network_connect_db:
  selinux.boolean:
    - name: httpd_can_network_connect_db
    - value: 1
    - persist: true

Set selinux boolean httpd_can_sendmail:
  selinux.boolean:
    - name: httpd_can_sendmail
    - value: 1
    - persist: true

Set selinux boolean httpd_can_network_connect:
  selinux.boolean:
    - name: httpd_can_network_connect
    - value: 1
    - persist: true

Set selinux boolean httpd_graceful_shutdown:
  selinux.boolean:
    - name: httpd_graceful_shutdown
    - value: 1
    - persist: true

Set selinux boolean httpd_can_network_relay:
  selinux.boolean:
    - name: httpd_can_network_relay
    - value: 1
    - persist: true

Install composer:
  pkg.installed:
    - name: composer

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
    - user: nginx
    - group: nginx

Link passbolt directory in /var/www:
  file.symlink:
    - target: /opt/passbolt_api-2.13.5
    - name: /var/www/passbolt_api

Set selinux context on passbolt:
  selinux.fcontext_policy_present:
    - name: /opt/passbolt_api-2.13.5(/.*)?
    - sel_type: httpd_sys_content_t

Apply selinux context for passbolt:
  selinux.fcontext_policy_applied:
    - name: /opt/passbolt_api-2.13.5
    - recursive: true

Set selinux context on config:
  selinux.fcontext_policy_present:
    - name: /opt/passbolt_api-2.13.5/config(/.*)?
    - sel_type: httpd_sys_rw_content_t

Apply selinux context for config:
  selinux.fcontext_policy_applied:
    - name: /opt/passbolt_api-2.13.5/config
    - recursive: true

Set selinux context on tmp:
  selinux.fcontext_policy_present:
    - name: /opt/passbolt_api-2.13.5/tmp(/.*)?
    - sel_type: httpd_sys_rw_content_t

Apply selinux context for tmp:
  selinux.fcontext_policy_applied:
    - name: /opt/passbolt_api-2.13.5/tmp
    - recursive: true

Create the .gnupg directory in httpd home:
  file.directory:
    - name: /usr/share/httpd/.gnupg
    - user: nginx
    - group: nginx
    - mode: 755

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
