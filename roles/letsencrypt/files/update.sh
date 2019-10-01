#!/bin/sh

cat /etc/domains.txt | while read provider username token domains; do
  export PROVIDER=$provider
  export PROVIDER_UP=`echo $provider | tr '[:lower:]' '[:upper:]'`

  eval "export LEXICON_${PROVIDER_UP}_USERNAME=${username}"
  eval "export LEXICON_${PROVIDER_UP}_TOKEN=${token}"
  domains_arg=""
  for domain in $domains; do
    domains_arg="${domains_arg} --domain $domain"
  done
  echo /usr/bin/dehydrated --config /etc/dehydrated/config --cron --hook /etc/dehydrated/hook.sh --challenge dns-01 ${domains_arg}
  /usr/bin/dehydrated --config /etc/dehydrated/config --cron --hook /etc/dehydrated/hook.sh --challenge dns-01 ${domains_arg}
done
