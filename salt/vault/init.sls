{% set vault_ip = salt['mine.get']('euw2a-prd-unixkingdom-vault-1', 'network.interface_ip')['euw2a-prd-unixkingdom-vault-1'] %}
Install jq:
  pkg.installed:
    - name: jq

Install cronie:
  pkg.installed:
    - name: cronie

Install certbot:
  pkg.installed:
    - pkgs:
      - certbot
      - python3-certbot-dns-ovh

Create OVH credentials:
  file.managed:
    - name: /root/.credentials.ini
    - source: salt://vault/credentials.ini
    - template: jinja
    - user: root
    - group: root
    - mode: 400

Initialize certificate:
  cmd.run:
    - name: certbot certonly --dns-ovh --dns-ovh-credentials ~/.credentials.ini --non-interactive --agree-tos --email edouard.camoin@gmail.com -d vault.unix-kingdom.fr -d pki.unix-kingdom.fr -d crl.unix-kingdom.fr

Crontab to renew certificate:
  cron.present:
    - name: cerbot renew --post-hook "systemctl reload vault"
    - user: root
    - minute: 0
    - hour: '0,12'

Adding unix-kingdom signing public key:
  file.managed:
    - source: https://repository.unix-kingdom.fr/RPM-GPG-KEY-unixkingdom
    - source_hash: 8ff53291cf3385d8298c595d1861370c67b29b2838e101abc39f46dec3467aec
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-unixkingdom
    - mode: 644
    - user: root
    - group: root

Adding unix-kingdom repository:
  pkgrepo.managed:
    - name: unixkingdom
    - enabled: true
    - humanname: unix-kingdom repository
    - baseurl: https://repository.unix-kingdom.fr/repos/fedora/$releasever/$basearch
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-unixkingdom
    - gpgcheck: 1

Install vault:
  pkg.installed:
    - name: vault
    - fromrepo: unixkingdom

Configure vault:
  file.managed:
    - source: salt://vault/vault.hcl
    - name: /etc/vault/vault.hcl
    - user: vault
    - group: vault
    - mode: 400
    - template: jinja

Start and enable vault service:
  service.running:
    - name: vault
    - enable: true
