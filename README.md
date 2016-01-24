Unbound :  sahilsk/unbound
---------

## Configuration


- root.hints: 

    It is the file which contains the listing of primary root DNS servers. Unbound does have a listing of root DNS servers in its code.
It should be updated every 6 month or so.


To query a hostname Unbound has to start at the top at the root DNS servers and work its way down to the authoritative servers (see the definition of a resolving DNS server above). Download a copy of the root hints from Internic and place it in the /var/unbound/etc/root.hints file. This file will be called by the root-hints: directive in the unbound.conf file.

    curl ftp://ftp.internic.net/domain/named.cache -o root.hints 

Store this file as `/var/unbound/etc/root/hints`

 To update before running set environment variable:
 
    UPDATE_ROOT_DNS_SERVERS="yes"` 


-  auto-trust-anchor-file

It contains the key for the root server so DNSSEC can be validated. We need to tell Unbound that we trust the root server so it can start to develop a chain of trust down to the hostname we want resolved and validated using DNSSEC.

You can independently verify the root zone anchor by going to the IANA.org Index of /root-anchors.

    . IN DS 19036 8 2 49AAC11D7B6F6446702E54A1607371607A1A41855200FD2CE1CDDE32F24E8FB5

Store it as`/var/unbound/etc/root.key`

## Dnsspoof with yoyo.org, anti-advertising list

Yoyo.org supplies a list of known advertising servers in a convenient text file which is updated periodically and pre-formated for unbound. The list will configure Unbound to redirect the ad server hostnames to localhost (127.0.0.1). Use curl to download the list to a new file called "unbound_ad_servers" and sed to clean up the HTML headers in the output. Once this file is in place you just need to add an "include:" directive to your unbound.conf pointing to the full path of the "unbound_ad_servers" file. Unbound will then redirect all 2400+ advertising servers to localhost keeping most, if not all advertising away from your systems. Simple, but powerful.

NOTE: Make sure you remove any "local-zone" entries that may be duplicated in the Yoyo ad server list. For example, if you have "local-zone: "doubleclick.net" redirect" in the unbound.conf and yoyo has the same "local-zone: "doubleclick.net" redirect" in their list then Unbound will fail to start due to the conflict.

Following script will fetch new add server list and put it in unbound directory,
followed by unbount reload, if unbound running as server

    block_ads_server.sh






