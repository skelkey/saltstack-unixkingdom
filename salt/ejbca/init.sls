Install Java 8 OpenJDK:
  pkg.installed:
    - name: java-1.8.0-openjdk

Install ant package:
  pkg.installed:
    - name: ant

Install mysql client:
  pkg.installed:
    - name: community-mysql

Create WildFly group:
  group.present:
    - name: wildfly
    - system: True
    - gid: 185
    
Create WildFly user:
  user.present:
    - name: wildfly
    - uid: 185
    - gid: 185
    - home: /opt/wildfly
    - createhome: False
    - shell: /sbin/nologin
    - fullname: The WildFly Application Server user

Download WildFly 10 archive:
  archive.extracted:
    - name: /opt/
    - source: https://download.jboss.org/wildfly/10.1.0.Final/wildfly-10.1.0.Final.zip
    - source_hash: '1e10c832b715ee7354a94ee57014dfe8ae419c10c536b17a36be030266e02508'
    - user: wildfly
    - group: wildfly

Create /opt/wildfly link:
  file.symlink:
    - name: /opt/wildfly
    - target: /opt/wildfly-10.1.0.Final

Install MariaDB JDBC connector in deployments:
  file.managed:
    - name: /opt/wildfly/standalone/deployments/mariadb-java-client-2.2.0.jar
    - source: https://downloads.mariadb.com/Connectors/java/connector-java-2.2.0/mariadb-java-client-2.2.0.jar
    - source_hash: https://downloads.mariadb.com/Connectors/java/connector-java-2.2.0/sha256sums.txt
    - user: wildfly
    - group: wildfly
    - mode: 0644

Install standalone configuration with MariaDB driver:
  file.managed:
    - name: /opt/wildfly/standalone/configuration/standalone.xml
    - source: salt://ejbca/standalone.xml
    - user: wildfly
    - group: wildfly
    - mode: 0644
    - template: jinja

Create systemd configuration service:
  file.managed:
    - name: /etc/wildfly/wildfly.conf
    - source: salt://ejbca/wildfly.conf
    - user: root
    - group: root
    - mode: 0644
    - makedirs: true
    
Create systemd service file:
  file.managed:
    - name: /etc/systemd/system/wildfly.service
    - source: salt://ejbca/wildfly.service
    - user: root
    - group: root
    - mode: 0644

Create launcher for wildfly script:
  file.managed:
    - name: /opt/wildfly/bin/launch.sh
    - source: salt://ejbca/launch.sh
    - user: wildfly
    - group: wildfly
    - mode: 0755

Increase allowed memory usage:
  file.managed:
    - name: /opt/wildfly/bin/standalone.conf
    - source: salt://ejbca/standalone.conf
    - user: wildfly
    - group: wildfly
    - mode: 0644

Start and enable wildfly service:
  service.running:
    - name: wildfly
    - enable: true

Create wildfly admin user:
  cmd.run:
    - name: bin/add-user.sh -u admin -p {{ pillar['wildfly_admin_password'] }} -r ManagementRealm -e
    - cwd: /opt/wildfly
    - runas: wildfly

Download EJBCA sources:
  archive.extracted:
    - name: /opt
    - source: https://netix.dl.sourceforge.net/project/ejbca/ejbca6/ejbca_6_15_2_1/ejbca_ce_6_15_2_1.zip
    - source_hash: '74743302559645761481ce17259541f2b0d66c97cea051c8dff511bb037642a7'
    - user: wildfly
    - group: wildfly

Configure EJBCA:
  file.managed:
    - name: /opt/ejbca_ce_6_15_2_1/conf/ejbca.properties
    - source: salt://ejbca/ejbca.properties
    - user: wildfly
    - group: wildfly
    - mode: 0644

Configure database for EJBCA:
  file.managed:
    - name: /opt/ejbca_ce_6_15_2_1/conf/database.properties
    - source: salt://ejbca/database.properties
    - user: wildfly
    - group: wildfly
    - template: jinja
    - mode: 400

Configure EJBCA web:
  file.managed:
    - name: /opt/ejbca_ce_6_15_2_1/conf/web.properties
    - source: salt://ejbca/web.properties
    - template: jinja
    - user: wildfly
    - group: wildfly
    - mode: 644

Configure EJBCA install:
  file.managed:
    - name: /opt/ejbca_ce_6_15_2_1/conf/install.properties
    - source: salt://ejbca/install.properties
    - user: wildfly
    - group: wildfly
    - mode: 644

Configure EJBCA cesecore:
  file.managed:
    - name: /opt/ejbca_ce_6_15_2_1/conf/cesecore.properties
    - source: salt://ejbca/cesecore.properties
    - template: jinja
    - user: wildfly
    - group: wildfly
    - mode: 400

Compile EJBCA:
  cmd.run:
    - name: ant clean deployear > /tmp/deployear
    - cwd: /opt/ejbca_ce_6_15_2_1
    - runas: wildfly
    - unless: test -f /opt/wildfly/standalone/deployments/ejbca.ear.deployed
    - timeout: 120

Install EJBCA:
  cmd.run:
    - name: sleep 120; ant runinstall > /tmp/runinstall
    - cwd: /opt/ejbca_ce_6_15_2_1
    - unless: test -f /opt/ejbca_ce_6_15_2_1/p12
    - runas: wildfly
    - timeout: 180

Deploy keystore:
  cmd.run:
    - name: ant deploy-keystore > /tmp/keystore
    - cwd: /opt/ejbca_ce_6_15_2_1
    - runas: wildfly
    - unless: test -d /opt/wildfly/standalone/configuration/keystore
    - timeout: 60

