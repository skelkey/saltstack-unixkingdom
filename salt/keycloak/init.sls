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

Install keycloak:
  pkg.installed:
    - name: keycloak

Configure keycloak operating mode:
  file.managed:
    - name: /etc/keycloak/wildfly.conf
    - source: salt://keycloak/wildfly.conf
    - user: root
    - group: root
    - mode: 644

Deploy jar file in keycloak module directory:
  file.managed:
    - name: /opt/keycloak/modules/system/layers/keycloak/org/mariadb/main/mariadb-java-client-1.4.6.jar
    - source: https://downloads.mariadb.com/Connectors/java/connector-java-1.4.6/mariadb-java-client-1.4.6.jar
    - source_hash: https://downloads.mariadb.com/Connectors/java/connector-java-1.4.6/sha256sums.txt
    - mode: 644
    - user: keycloak
    - group: keycloak
    - creates: true

Deploy module.xml in keycloak module directory:
  file.managed:
    - name: /opt/keycloak/modules/system/layers/keycloak/org/mysql/main/module.xml
    - source: salt://keycloak/module.xml
    - mode: 644
    - user: keycloak
    - group: keycloak
    - creates: true

Deploy standalone-ha.xml in keycloak configuration:
  file.managed:
    - name: /opt/keycloak/standalone/configuration/standalone-ha.xml
    - source: salt://keycloak/standalone-ha.xml
    - mode: 644
    - user: keycloak
    - group: keycloak
    - template: jinja

Start and enable keycloak service:
  service.running:
    - name: keycloak
    - enable: true
