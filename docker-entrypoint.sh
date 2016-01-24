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
    ##sed -i 's/#include: "\/etc\/unbound\/local.d\/unbound_ad_servers"/include: "\/etc\/unbound\/local.d\/unbound_ad_servers\"/' /etc/unbound/unbound.conf
fi

if [ ! -z "$CACHE_MIN_TTL" ]
then
    sed -i -E "s/(.*)cache-min-ttl: (.*)/cache-min-ttl: $CACHE_MIN_TTL/" /etc/unbound/unbound.conf
fi

if [ ! -z "$CACHE_MAX_TTL" ]
then
    sed -i -E "s/(.*)cache-max-ttl: (.*)/cache-max-ttl: $CACHE_MAX_TTL/" /etc/unbound/unbound.conf
fi

if [ ! -z "$NUM_THREADS" ]
then
    sed -i -E "s/(.*)num-threads: (.*)/num-threads: $NUM_THREADS/" /etc/unbound/unbound.conf
else
    ## Tweak num threads
    procs=$(cat /proc/cpuinfo |grep processor | wc -l)
    sed -i -E "s/(.*)num-threads: (.*)/num-threads: $procs/" /etc/unbound/unbound.conf
fi

## Sync clocks,else you'll get  "Fix failed to prime trust anchor" errors
echo "Syncing clock with 130.206.3.166"
ntpd -n -q -N -p 130.206.3.166

## Start unbound if no args given
if [ "$#" -gt 0 ]
then
    $@
else
    unbound -d
fi
