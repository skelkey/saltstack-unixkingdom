Install createrepo package:
  pkg.installed:
    - name: createrepo

Create directory /srv/repos/fedora/28/x86_64/RPMS:
  file.directory:
    - name: /srv/repos/fedora/28/x86_64/RPMS
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

Create directory /srv/repos/fedora/28/SRPMS:
  file.directory
    - name: /srv/repos/fedora/28/SRPMS
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

Repository creation:
  cmd.run:
    - name: createrepo
    - cwd: /srv/repos/fedora/28/x86_64
    - user: root


