{% set vault_ip = salt['mine.get']('euw2a-prd-unixkingdom-vault-1', 'network.interface_ip')['euw2a-prd-unixkingdom-vault-1'] %}
ui = true

storage "s3" {
  endpoint   = "https://osu.eu-west-2.outscale.com"
  region     = "eu-west-2"
  bucket     = "euw2a-prd-unixkingdom-vault"
  access_key = "{{ pillar['vault_access_key'] }}"
  secret_key = "{{ pillar['vault_secret_key'] }}"
}

listener "tcp" {
  address         = "{{ vault_ip }}:8443"
  tls_cert_file   = "/etc/letsencrypt/live/vault.unix-kingdom.fr/fullchain.pem"
  tls_key_file    = "/etc/letsencrypt/live/vault.unix-kingdom.fr/privkey.pem"
  tls_min_version = "tls12"
}
