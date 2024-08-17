#!/bin/sh
# ubcache.sh - automatic save and restore of unbound cache by JGrana mod by monkitrainer

case "$1" in
        restore)
        for i in 1 2 3 4 5 6 7 8 9 10; do  # wait for ubound to start (around a minute)
        if [ `pgrep -x "unbound"` ]; then
                rtime=`date | awk '{print $4}'`
                rhour=$(date -d $rtime +%s)
                ftime=`ls -e /opt/share/unbound/configs/uncache.txt | awk '{print $9}'`
                fhour=$(date -d $ftime +%s)
                dhour=$(($fhour + 600))  # cache valid time - 10 mins

                if [ $dhour -lt $rhour ]; then
                        logger -t ubcache "Unbound cache too old, no restore"
                        exit;
                else
                        logger -t ubcache "Restored Unbound Cache" ;
                        unbound-control load_cache < /opt/share/unbound/configs/uncache.txt

                fi
                break
        else
                sleep 5 # wait for ubound to start
        fi
        done
        ;;

        save)
        logger -t ubcache "Saving Unbound Cache"
        unbound-control dump_cache > /opt/share/unbound/configs/uncache.txt ;;
        *) echo "Usage: ubcache [save] [restore]" ; exit 1
         ;;
esac
