Install createrepo package:
  pkg.installed:
    - name: createrepo

Install nginx package:
  pkg.installed:
    - name: nginx

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

Repository creation:
  cmd.run:
    - name: createrepo .
    - cwd: /srv/repos/fedora/28/x86_64
    - user: root
    - unless: test -d /srv/repos/fedora/28/x86_64/repodata

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

Start and enable nginx:
  service.running:
    - name: nginx
    - enable: true

Reload nginx service:
  module.wait:
    - name: service.reload
    - m_name: nginx

Verify httpd selinux context:
  selinux.fcontext_policy_present:
    - name: "^/srv(/.*)?"
    - sel_type: "httpd_sys_content_t"

Apply httpd selinux context:
  selinux.fcontext_policy_applied:
    - name: "^/srv(/.*)?"
    - recursive: True
