Create user bitwarden:
  user.present:
    - name: bitwarden
    - usergroup: bitwarden
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
    - enforce_toplevel: false
    
Deploy bitwarden identity certificate:
  file.managed:
    - name: /opt/bitwarden/identity/identity.pfx
    - user: bitwarden
    - group: bitwarden
    - mode: 400
     - contents_pillar:
       - identity_pfx
       
Deploy bitwarden global override env file:
  file.managed:
    - name: /opt/bitwarden/env/global.override.env
    - source: salt://bitwarden/global.override.env
    - user: bitwarden
    - group: bitwarden
    - mode: 640
    - template: jinja

Deploy bitwarden mssql override env file:
  file.managed:
    - name: /opt/bitwarden/env/mssql.override.env
    - source: salt://bitwarden/mssql.override.env
    - user: bitwarden
    - group: bitwarden
    - mode: 640
    - template: jinja

Deploy bitwarden app-id.json file:
  file.managed:
    - name: /opt/bitwarden/web/app-id.json
    - source: salt://bitwarden/app-id.json
    - user: bitwarden
    - group: bitwarden
    - mode: 640

Deploy bitwarden uid environment file:
  file.managed:
    - name: /opt/bitwarden/env/uid.env
    - source: salt://bitwarden/uid.env
    - user: bitwarden
    - group: bitwarden
    - mode: 640
    - template: jinja

Deploy bitwarden certificate:
  file.managed:
    - name: /opt/bitwarden/ssl/bitwarden.pem
    - user: bitwarden
    - group: bitwarden
    - mode: 640
    - contents_pillar:
      - bitwarden_crt
      - server_unixkingdom_ca
      - unixkingdom_ca

Deploy bitwarden private key:
  file.managed:
    - name: /opt/bitwarden/ssl/bitwarden.key
    - user: bitwarden
    - group: bitwarden
    - mode: 640
    - contents_pillar:
      - bitwarden_key
 
