{% set root_path = "/opt/webadm" %}
{% set current_path = salt['environ.get']('PATH', '/bin:/usr/bin') %}
{% set library_path = salt['environ.get']('LD_LIBRARY_PATH', '') %}

Install rcdevs GPG key:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-rcdevs
    - source: https://www.rcdevs.com/repos/redhat/RPM-GPG-KEY-rcdevs.pub
    - source_hash: fd61fca7158401ae72d134fc68170c005c11c8971f6d8f97a0c56d72ab8c0c94
    - user: root
    - group: root
    - mode: 644

Install RCDevs repository:
  pkgrepo.managed:
    - name: rcdevs
    - enabled: True
    - humanname: rcdevs
    - baseurl: https://www.rcdevs.com/repos/redhat
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rcdevs
    - protect: 0

Install make tools:
  pkg.installed:
    - name: make

Install OpenLDAP tools:
  pkg.installed:
    - name: openldap-clients

Install RCDevs webadm:
  pkg.installed:
    - name: webadm

Install RCDevs selfdesk application:
  pkg.installed:
   - pkgs:
     - selfdesk
     - openid
     - openotp
     - opensso
     - spankey

Create webadm group:
  group.present:
    - name: webadm
    - system: true

Create webadm user:
  user.present:
    - name: webadm
    - gid_from_name: webadm
    - home: /opt/webadm
    - shell: /sbin/nologin
    - system: true

Deploy servers.xml file:
  file.managed:
    - name: /opt/webadm/conf/servers.xml
    - source: salt://webadm/servers.xml
    - user: root
    - group: root
    - mode: 644
    - template: jinja

Deploy webadm.conf file:
  file.managed:
    - name: /opt/webadm/conf/webadm.conf
    - source: salt://webadm/webadm.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

Deploy objects.xml file:
  file.managed:
    - name: /opt/webadm/conf/objects.xml
    - source: salt://webadm/objects.xml
    - user: root
    - group: root
    - mode: 644

Deploy rsignd.conf file:
  file.managed:
    - name: /opt/webadm/conf/rsignd.conf
    - source: salt://webadm/rsignd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

Create webadm private key:
  cmd.run:
    - name: $OPENSSL genrsa -out $SSL_KEY 2048
    - onlyif: test ! -e /opt/webadm/pki/webadm.key
    - cwd: /opt/webadm/
    - env:
      - ROOT: '/opt/webadm'
      - OPENSSL: '{{ root_path }}/libexec/openssl'
      - RANDFILE: '{{ root_path }}/temp/webadm.rnd'
      - CA_KEY: '{{ root_path }}/pki/ca/ca.key'
      - CA_CRT: '{{ root_path }}/pki/ca/ca.crt'
      - CA_SER: '{{ root_path }}/pki/ca/serial'
      - SSL_KEY: '{{ root_path }}/pki/webadm.key'
      - SSL_CRT: '{{ root_path }}/pki/webadm.crt'
      - SSL_CSR: '{{ root_path }}/pki/webadm.csr'
      - PATH: '{{ root_path }}/libexec:/bin:/sbin:/usr/bin:/usr/sbin:{{ current_path }}'
      - LD_LIBRARY_PATH: '{{ root_path }}/lib:{{ root_path }}/lib/gnulib:/opt/slapd/lib/:{{ library_path }}'
      - OPENSSL_CONF: '{{ root_path }}/lib/openssl.ini'
      - OPENSSL_SAN: ''
      
Set correct right on webadm private key:
  file.managed:
    - name: /opt/webadm/pki/webadm.key
    - mode: 600

Create webadm certificate request:
  cmd.run:
    - name: $OPENSSL req -new -key $SSL_KEY -out $SSL_CSR -subj "/CN=euw2a-prd-unixkingdom-webadm-1/O=UnixKingdom"
    - onlyif: test ! -e /opt/webadm/pki/webadm.csr
    - cwd: /opt/webadm/
    - env:
      - ROOT: '/opt/webadm'
      - OPENSSL: '{{ root_path }}/libexec/openssl'
      - RANDFILE: '{{ root_path }}/temp/webadm.rnd'
      - CA_KEY: '{{ root_path }}/pki/ca/ca.key'
      - CA_CRT: '{{ root_path }}/pki/ca/ca.crt'
      - CA_SER: '{{ root_path }}/pki/ca/serial'
      - SSL_KEY: '{{ root_path }}/pki/webadm.key'
      - SSL_CRT: '{{ root_path }}/pki/webadm.crt'
      - SSL_CSR: '{{ root_path }}/pki/webadm.csr'
      - PATH: '{{ root_path }}/libexec:/bin:/sbin:/usr/bin:/usr/sbin:{{ current_path }}'
      - LD_LIBRARY_PATH: '{{ root_path }}/lib:{{ root_path }}/lib/gnulib:/opt/slapd/lib/:{{ library_path }}'
      - OPENSSL_CONF: '{{ root_path }}/lib/openssl.ini'
      - OPENSSL_SAN: ''

Create webadm certificate:
  cmd.run:
    - name: $OPENSSL x509 -req -days 365 -in $SSL_CSR -out $SSL_CRT -CA $CA_CRT -CAkey $CA_KEY -CAserial $CA_SER
    - onlyif: test ! -e /opt/webadm/pki/webadm.crt
    - cwd: /opt/webadm
    - env:
      - ROOT: '/opt/webadm'
      - OPENSSL: '{{ root_path }}/libexec/openssl'
      - RANDFILE: '{{ root_path }}/temp/webadm.rnd'
      - CA_KEY: '{{ root_path }}/pki/ca/ca.key'
      - CA_CRT: '{{ root_path }}/pki/ca/ca.crt'
      - CA_SER: '{{ root_path }}/pki/ca/serial'
      - SSL_KEY: '{{ root_path }}/pki/webadm.key'
      - SSL_CRT: '{{ root_path }}/pki/webadm.crt'
      - SSL_CSR: '{{ root_path }}/pki/webadm.csr'
      - PATH: '{{ root_path }}/libexec:/bin:/sbin:/usr/bin:/usr/sbin:{{ current_path }}'
      - LD_LIBRARY_PATH: '{{ root_path }}/lib:{{ root_path }}/lib/gnulib:/opt/slapd/lib/:{{ library_path }}'
      - OPENSSL_CONF: '{{ root_path }}/lib/openssl.ini'
      - OPENSSL_SAN: ''

Set correct right on webadm certificate:
  file.managed:
    - name: /opt/webadm/pki/webadm.crt
    - mode: 644

Deploy custom.key file:
  file.managed:
    - name: /opt/webadm/pki/custom.key
    - source: salt://webadm/custom.key
    - user: root
    - group: root
    - mode: 400
    - template: jinja

Deploy custom.crt file:
  file.managed:
    - name: /opt/webadm/pki/custom.crt
    - source: salt://webadm/custom.crt
    - user: root
    - group: root
    - mode: 644
    - template: jinja

Deploy ca.key file:
  file.managed:
    - name: /opt/webadm/pki/ca/ca.key
    - source: salt://webadm/ca.key
    - user: root
    - group: root
    - mode: 644
    - template: jinja

Deploy ca.crt file:
  file.managed:
    - name: /opt/webadm/pki/ca/ca.crt
    - source: salt://webadm/ca.crt
    - user: root
    - group: root
    - mode: 644
    - template: jinja

Create systemd service file:
  file.managed:
    - name: /etc/systemd/system/webadm.service
    - source: salt://webadm/webadm.service
    - user: root
    - group: root
    - mode: 0755

Add unixkingdom_ca to webadm truststore:
  file.managed:
    - name: /opt/webadm/pki/trusted/unixkingdom.crt
    - contents_pillar: unixkingdom_ca

Add people_unixkingdom_ca to webadm truststore:
  file.managed:
    - name: /opt/webadm/pki/trusted/people_unixkingdom.crt
    - contents_pillar: webadm_cacert

Compiling trusted certificate store:
  cmd.run:
    - name: make
    - cwd: /opt/webadm/pki/trusted

start and enable webadm service:
  service.running:
    - name: webadm
    - enable: true
