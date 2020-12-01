Create user bitwarden:
  user.present:
    - name: bitwarden
    - gid_from_name: bitwarden
    - home: /opt/bitwarden
    - shell: /sbin/nologin
    - system: true

Extract docker image:
  archive.extracted:
    - name: /opt/bitwarden/
    - source: https://github.com/bitwarden/server/releases/download/v1.38.1/docker-stub.zip
    - source_hash: 3d7211ee4a009520e6e38b6a64ad23fdd9b6bf62e6c7645aa0ffea3e80a2c229
    - user: bitwarden
    - group: bitwarden
    

