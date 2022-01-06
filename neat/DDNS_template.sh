#!/bin/bash
# Update the DNS records for "freedns.afraid.org".
domain='mr.beansbook.com'
secretURL='http://sync.afraid.org/u/xxxxxxxxxxxxxxxxxxxxxxxx/'
logFile='/home/pi/beanDNS.log'
{
    date -Iseconds
    until curl "$secretURL" --silent --show-error; do
        sleep 5
    done
} >> "$logFile"
exit 0
