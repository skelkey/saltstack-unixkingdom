{% set vault_ip = salt['mine.get']('euw2a-prd-unixkingdom-vault-1', 'network.interface_ip')['euw2a-prd-unixkingdom-vault-1'] %}

Install jq:
  pkg.installed:
    - name: jq

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

Initialize vault:
  cmd.run:
    - env:
      - VAULT_ADDR: "http://{{ vault_ip }}:8200"
    - vault operator init -key-shares=1 -key-threshold=1
    - runas: root
    - onlyif: vault status -format=json |jq .initialized |grep true 
    
