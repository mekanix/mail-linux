smtpd_banner = $myhostname ESMTP $mail_name
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

readme_directory = no

# TLS parameters
smtpd_tls_cert_file = /etc/dehydrated/certs/{{ domain }}/fullchain.pem
smtpd_tls_key_file = /etc/dehydrated/certs/{{ domain }}/privkey.pem
smtpd_use_tls = yes
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_auth_enable=yes
smtpd_recipient_restrictions =
    permit_mynetworks
    permit_sasl_authenticated
    reject_unauth_destination
    reject_unauth_pipelining
    reject_non_fqdn_helo_hostname
    reject_non_fqdn_sender
    reject_unauth_destination
#    check_policy_service unix:private/policy
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtpd_client_restrictions = permit_mynetworks
smtpd_helo_required = yes
smtpd_helo_restrictions = permit_mynetworks, reject_invalid_helo_hostname
smtpd_delay_reject = yes
smtpd_relay_restrictions =
    permit_mynetworks
    permit_sasl_authenticated
    defer_unauth_destination

smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

# See /usr/share/doc/postfix/TLS_README.gz in the postfix-doc package for
# information on enabling SSL in the smtp client.

myhostname = comms.{{ domain }}
alias_maps = hash:/etc/mail/aliases
alias_database = hash:/etc/mail/aliases
myorigin = {{ domain }}
mydestination =
    comms.{{ domain }}
    localhost
relayhost =
mynetworks = 127.0.0.0/8 10.0.0.0/16 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_transport = dovecot
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
transport_maps = hash:/usr/local/etc/postfix/transport

virtual_alias_maps = ldap:aliases
virtual_mailbox_domains = ldap:domains
virtual_transport = dovecot
dovecot_destination_recipient_limit = 1

aliases_server_host = ldap
aliases_search_base = ou=%d, dc=ldap
aliases_query_filter = (&(uid=%u)(objectClass=person))
aliases_result_attribute = mail
aliases_scope = sub
aliases_cache = no
aliases_bind = no
aliases_version = 3

domains_server_host = ldap
domains_search_base = dc=ldap
domains_query_filter = (&(ou=%s)(objectClass=organizationalUnit))
domains_result_attribute = ou
domains_scope = sub
domains_cache = no
domains_bind = no
domains_version = 3

milter_default_action = accept
smtpd_milters = inet:mail:11332
non_smtpd_milters = inet:mail:11332

body_checks_size_limit = 26214400
message_size_limit = 26214400
compatibility_level = 2

inet_protocols = ipv4
