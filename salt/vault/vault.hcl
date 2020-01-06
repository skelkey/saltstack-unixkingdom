ui = true

storage "s3" {
  endpoint   = "https://osu.eu-west-2.outscale.com"
  region     = "eu-west-2"
  bucket     = "euw2a-prd-unixkingdom-vault"
  access_key = "{{ pillar['vault_access_key'] }}"
  secret_key = "{{ pillar['vault_secret_key'] }}"
}

listener "tcp" {
  address     = "172.16.4.75:8200"
}
