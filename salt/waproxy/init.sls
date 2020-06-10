{% set root_path = "/opt/waproxy" %}
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

Install RCDevs waproxy:
  pkg.installed:
    - name: waproxy

Create waproxy group:
  group.present:
    - name: waproxy
    - system: true

Create waproxy user:
  user.present:
    - name: waproxy
    - gid_from_name: waproxy
    - home: /opt/waproxy
    - shell: /sbin/nologin
    - system: true

Configure waproxy:
  file.managed:
    - name: /opt/waproxy/conf/waproxy.conf
    - source: salt://waproxy/waproxy.conf
    - user: root
    - group: root
    - mode: 644

Create waproxy private key:
  cmd.run:
    - name: $OPENSSL genrsa -out $ROOT/conf/waproxy.key 2048
    - onlyif: test ! -e /opt/waproxy/conf/waproxy.key
    - cwd: /opt/waproxy/
    - env:
      - ROOT: '/opt/waproxy'
      - OPENSSL: '{{ root_path }}/libexec/openssl'
      - PATH: '{{ root_path }}/libexec:/bin:/sbin:/usr/bin:/usr/sbin:{{ current_path }}'
      - LD_LIBRARY_PATH: '{{ root_path }}/lib:{{ root_path }}/lib/gnulib:/opt/slapd/lib/:{{ library_path }}'
      - OPENSSL_CONF: '{{ root_path }}/lib/openssl.ini'
      - OPENSSL_SAN: ''

Set correct right on waproxy private key:
  file.managed:
    - name: /opt/waproxy/conf/waproxy.key
    - mode: 600

Create waproxy certificate request:
  cmd.run:
    - name: $OPENSSL req -new -key $ROOT/conf/waproxy.key -out $ROOT/conf/waproxy.csr -subj "/CN=euw2a-prd-unixkingdom-waproxy-1/O=UnixKingdom"
    - onlyif: test ! -e /opt/waproxy/conf/waproxy.csr
    - cwd: /opt/waproxy/
    - env:
      - ROOT: '/opt/waproxy'
      - OPENSSL: '{{ root_path }}/libexec/openssl'
      - PATH: '{{ root_path }}/libexec:/bin:/sbin:/usr/bin:/usr/sbin:{{ current_path }}'
      - LD_LIBRARY_PATH: '{{ root_path }}/lib:{{ root_path }}/lib/gnulib:/opt/slapd/lib/:{{ library_path }}'
      - OPENSSL_CONF: '{{ root_path }}/lib/openssl.ini'
      - OPENSSL_SAN: ''

Create waproxy certificate:
  cmd.run:
    - name: $OPENSSL x509 -req -days 365 -in $ROOT/conf/waproxy.csr -signkey $ROOT/conf/waproxy.key -out $ROOT/conf/waproxy.crt
    - onlyif: test ! -e /opt/waproxy/conf/waproxy.crt
    - cwd: /opt/waproxy
    - env:
      - ROOT: '/opt/waproxy'
      - OPENSSL: '{{ root_path }}/libexec/openssl'
      - PATH: '{{ root_path }}/libexec:/bin:/sbin:/usr/bin:/usr/sbin:{{ current_path }}'
      - LD_LIBRARY_PATH: '{{ root_path }}/lib:{{ root_path }}/lib/gnulib:/opt/slapd/lib/:{{ library_path }}'
      - OPENSSL_CONF: '{{ root_path }}/lib/openssl.ini'
      - OPENSSL_SAN: ''

Set correct right on waproxy certificate:
  file.managed:
    - name: /opt/waproxy/conf/waproxy.crt
    - mode: 644

Set waproxy custom certificate:
  file.managed:
    - name: /opt/waproxy/conf/custom.crt
    - source: salt://waproxy/custom.crt
    - user: root
    - group: root
    - mode: 644
    - template: jinja

Set waproxy custom private key:
  file.managed:
    - name: /opt/waproxy/conf/custom.key
    - source: salt://waproxy/custom.key
    - user: root
    - group: root
    - mode: 600
    - template: jinja

Install certificate chain for waproxy:
  file.managed:
    - name: /opt/waproxy/conf/ca.crt
    - source: salt://waproxy/ca.crt
    - user: root
    - group: root
    - mode: 644
    - template: jinja

start and enable waproxy service:
  service.running:
    - name: waproxy
    - enable: true
