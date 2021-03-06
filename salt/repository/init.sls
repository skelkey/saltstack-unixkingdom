Install createrepo package:
  pkg.installed:
    - name: createrepo

Install nginx package:
  pkg.installed:
    - name: nginx

Install cron:
  pkg.installed:
    - name: cronie

Start and enable cronie:
  service.running:
    - name: crond
    - enable: true

Create directory /srv/repos/fedora/28/x86_64/RPMS:
  file.directory:
    - name: /srv/repos/fedora/28/x86_64/RPMS
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

Create directory /srv/repos/fedora/28/SRPMS:
  file.directory:
    - name: /srv/repos/fedora/28/SRPMS
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

Create directory /srv/repos/fedora/33/x86_64/RPMS:
  file.directory:
    - name: /srv/repos/fedora/33/x86_64/RPMS
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

Create directory /srv/repos/fedora/33/x86_64/SRPMS:
  file.directory:
    - name: /srv/repos/fedora/33/x86_64/SRPMS
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

Deploy repository GPG key:
  file.managed:
    - name: /srv/RPM-GPG-KEY-unixkingdom
    - source: salt://repository/RPM-GPG-KEY-unixkingdom
    - user: root
    - group: root
    - mode: 644
    - template: jinja

Configure nginx:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://repository/nginx.conf
    - user: root
    - group: root
    - mode: 644

Verify httpd selinux context:
  selinux.fcontext_policy_present:
    - name: "/srv(/.*)?"
    - sel_type: "httpd_sys_content_t"

Apply httpd selinux context:
  selinux.fcontext_policy_applied:
    - name: "/srv(/.*)?"
    - recursive: True

Deploy vault rpm in repository:
  file.managed:
    - name: /srv/repos/fedora/28/x86_64/RPMS/vault-1.3.0-1.fc28.x86_64.rpm
    - source: https://osu.eu-west-2.outscale.com/repository/vault-1.3.0-1.fc28.x86_64.rpm
    - source_hash: http://repository.osu.eu-west-2.outscale.com/vault-1.3.0-1.fc28.x86_64.rpm.sha512
    - user: root
    - group: root
    - mode: 644

Deploy php-pecl-gnupg in repository:
  file.managed:
    - name: /srv/repos/fedora/33/x86_64/RPMS/php-pecl-gnupg-1.4.0-9.fc33.remi.7.4.x86_64.rpm
    - source: https://osu.eu-west-2.outscale.com/repository/php-pecl-gnupg-1.4.0-9.fc33.remi.7.4.x86_64.rpm
    - source_hash: http://repository.osu.eu-west-2.outscale.com/php-pecl-gnupg-1.4.0-9.fc33.remi.7.4.x86_64.rpm.sha512
    - user: root
    - group: root
    - mode: 644

Repository creation for fedora 28:
  cmd.run:
    - name: createrepo .
    - cwd: /srv/repos/fedora/28/x86_64
    - user: root

Repository creation for fedora 33:
  cmd.run:
    - name: createrepo .
    - cwd: /srv/repos/fedora/33/x86_64
    - user: root

Install certbot:
  pkg.installed:
    - pkgs:
      - certbot
      - python3-certbot-dns-ovh

Create OVH credentials:
  file.managed:
    - name: /root/.credentials.ini
    - source: salt://repository/credentials.ini
    - template: jinja
    - user: root
    - group: root
    - mode: 400

Initialize certificate:
  cmd.run:
    - name: certbot certonly --dns-ovh --dns-ovh-credentials ~/.credentials.ini --non-interactive --agree-tos --email edouard.camoin@gmail.com -d repository.unix-kingdom.fr

Crontab to renew certificate:
  cron.present:
    - name: /usr/bin/certbot renew --post-hook "systemctl restart nginx"
    - user: root
    - minute: 0
    - hour: '0,12'

Start and enable nginx:
  service.running:
    - name: nginx
    - enable: true

Reload nginx service:
  module.wait:
    - name: service.reload
    - m_name: nginx

