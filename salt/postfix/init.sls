Install postfix packages:
  pkg.installed:
    - pkgs:
      - postfix
      - cyrus-sasl-plain

Install opendkim packages:
  pkg.installed:
    - pkgs:
      - opendkim
      - perl-Getopt-Long

Create directory for unix-kingdom DKIM:
  file.directory:
    - name: /etc/opendkim/keys/unix-kingdom.fr
    - user: opendkim
    - group: opendkim
    - mode: 750
    - makedirs: True

Generate DKIM keys:
  cmd.run:
    - name: opendkim-genkey -D /etc/opendkim/keys/unix-kingdom.fr -d unix-kingdom.fr -s default
    - unless: test -f /etc/opendkim/keys/unix-kingdom.fr/default.private

Set correct right on keys:
  file.managed:
    - name: /etc/opendkim/keys/unix-kingdom.fr/default.private
    - user: opendkim
    - group: opendkim
    - mode: 640

Set correct right on public keys:
  file.managed:
    - name: /etc/opendkim/keys/unix-kingdom.fr/default.txt
    - user: opendkim
    - group: opendkim
    - mode: 644

Configure OpenDKIM:
  file.managed:
    - name: /etc/opendkim.conf
    - source: salt://postfix/opendkim.conf
    - user: opendkim
    - group: opendkim
    - mode: 644

Configure TrustedHosts for DKIM:
  file.managed:
    - name: /etc/opendkim/TrustedHosts
    - source: salt://postfix/TrustedHosts
    - user: opendkim
    - group: opendkim
    - mode: 644

Configure KeyTable for DKIM:
  file.managed:
    - name: /etc/opendkim/KeyTable
    - source: salt://postfix/KeyTable
    - user: opendkim
    - group: opendkim
    - mode: 644

Configure SigningTable for DKIM:
  file.managed:
    - name: /etc/opendkim/SigningTable
    - source: salt://postfix/SigningTable
    - user: opendkim
    - group: opendkim
    - mode: 644

Deploy postfix private key:
  file.managed:
    - name: /etc/pki/tls/private/postfix.key
    - mode: 600
    - user: postfix
    - group: postfix
    - contents_pillar: postfix_key

Deploy postfix certificate:
  file.managed:
    - name: /etc/pki/tls/certs/postfix.crt
    - mode: 640
    - user: postfix
    - group: postfix
    - contents_pillar: postfix_crt

Deploy unixkingdom chain:
  file.managed:
    - name: /etc/pki/tls/certs/chain.crt
    - mode: 640
    - user: postfix
    - group: postfix
    - contents_pillar:
      - server_unixkingdom_ca
      - unixkingdom_ca

Set right on opendkim run directory:
  file.directory:
    - name: /run/opendkim
    - mode: 750

Deploy main.cf configuration for postfix:
  file.managed:
    - name: /etc/postfix/main.cf
    - source: salt://postfix/main.cf
    - user: root
    - group: root
    - mode: 644

Deploy master.cf configuration for postfix:
  file.managed:
    - name: /etc/postfix/master.cf
    - source: salt://postfix/master.cf
    - user: root
    - group: root
    - mode: 644

Deploy postfix client blacklist:
  file.managed:
    - name: /etc/postfix/blacklist
    - source: salt://postfix/blacklist
    - user: root
    - group: root
    - mode: 644

Compile postfix client blacklist:
  cmd.run:
    - name: postmap /etc/postfix/blacklist

start and enable opendkim service:
  service.running:
    - name: opendkim
    - enable: true

start and enable postfix service:
  service.running:
    - name: postfix
    - enable: true
