Install RCDevs repository:
  pkg.installed:
    - sources:
      - rcdevs: https://www.rcdevs.com/repos/redhat/rcdevs_release-1.0.0-0.noarch.rpm

Install RCDevs ldap:
  pkg.installed:
    - name: slapd
