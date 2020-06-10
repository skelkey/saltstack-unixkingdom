# Information

These salt rules can be used to deploy and manage the UnixKingdom servers configuration

# Deployment order

Because there is interdepencies between some component and egg-and-chicken problem in the deployment.
1. bind
2. repository
3. vault, mariadb, ldap 
4. webadm, radius
5. waproxy
