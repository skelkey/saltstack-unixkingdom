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

Set correct righ on public keys:
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
    - name: /etc/mail/postfix.key
    - mode: 600
    - user: root
    - group: root
    - contents_pillar: postfix_key

Deploy postfix certificate:
  file.managed:
    - name: /etc/mail/postfix.crt
    - mode: 640
    - user: root
    - group: root
    - contents_pillar: postfix_crt

Deploy unixkingdom chain:
  file.managed:
    - name: /etc/mail/chain.crt
    - mode: 640
    - user: root
    - group: root
    - contents_pillar:
      - server_unixkingdom_ca
      - unixkingdom_ca

Create dhparam for postfix:
  cmd.run:
    - name: openssl dhparam -out /etc/mail/postfix.dh.param 2048
    - unless: test -f /etc/mail/postfix.dh.param

Set right on opendkim run directory:
  file.directory:
    - name: /run/opendkim
    - mode: 750

start and enable opendkim service:
  service.running:
    - name: opendkim
    - enable: true

start and enable postfix service:
  service.running:
    - name: postfix
    - enable: true
