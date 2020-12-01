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
    - source_hash: 80989e0b2bb70620ee65a923ac606374f7257f1095905e2e3bd0b34f8f671959
    - user: bitwarden
    - group: bitwarden
    

