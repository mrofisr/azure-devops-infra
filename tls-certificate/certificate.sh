#!/bin/bash
certbot certonly --manual \
-d $DOMAIN \
--agree-tos \
--manual-public-ip-logging-ok \
--preferred-challenges dns-01 \
--server https://acme-v02.api.letsencrypt.org/directory \
--register-unsafely-without-email --rsa-key-size 4096
