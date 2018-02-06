#! /bin/bash
# Functie: Aanmaken SSL-certificaat voor website op pbiscayne1
# Datum:   20170130
# Special voor VPS

echo -n "Enter domain name (zonder www): "
read domainname

/opt/letsencrypt/letsencrypt-auto --apache -d $domainname -d www.$domainname
