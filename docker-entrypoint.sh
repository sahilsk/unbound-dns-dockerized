#!/bin/sh


SCRIPT_DIR="/var/unbound/scripts"

cd /var/unbound/etc 

if [ "$UPDATE_ROOT_DNS_SERVERS" = "yes" ]
then
    curl ftp://ftp.internic.net/domain/named.cache -o /var/unbound/etc/root.hints
fi

## Block Ads
if [ "$BLOCK_ADS" = "yes" ]
then
    . $SCRIPT_DIR/block_ads_server.sh
    # Get server list
    sed -i 's/#include\: \/etc\/unbound\/local.d\/unbound_ad_server/inlclude\: \/etc\/unbound\/local\.d\/unbound_ad_server'
fi


## Start unbound if no args given
if [ "$#" -gt 0 ]
then
    $@
else
    unbound -d 
fi
