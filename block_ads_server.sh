#!/bin/bash 

CONF_DIR="/etc/unbound/local.d"

if [ -z "$BLOCK_ADS" ]
then 
  BLOCK_ADS="no"
fi

if [ "$BLOCK_ADS" = "no" ]
then
    echo "Skipping ads blocker..."
    exit 0
fi

echo "Fetching ads server list..."

if [ -z "$BLOCK_SERVER_PROVIDER"]
then
  BLOCK_SERVER_PROVIDER="yoyo"
fi

if [ "$BLOCK_SERVER_PROVIDER" = "benstaker" ]
then
    ## Method: 1
    ####################
    echo "Using ads sever list provided by http://benstasker.co.uk.."
    cd rm $CONF_DIR/unbound_ad_servers
    for a in `wget -O - "http://www.bentasker.co.uk/adblock/autolist.txt"`; do echo "       local-data: \"$a A 127.0.0.2\"" >> $CONF_DIR/unbound_ad_servers; done

elif [ "$BLOCK_SERVER_PROVIDER" = "yoyo" ]
then
    ## Method: 2
    ####################
    echo "Using ads sever list provided by http://pgl.yoyo.org"
    curl -sS -L --compressed "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=unbound&showintro=0&mimetype=plaintext" > $CONF_DIR/unbound_ad_servers

fi


## Uncomment if unbound running as service
#service unbound reload
