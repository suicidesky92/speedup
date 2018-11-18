#!/bin/bash
  
for ((i=1; i<882;i++))
do

USERR=$(( ( RANDOM % 9900 )  + 1 ))
TIMEW=$(( ( RANDOM % 4 )  + 1 ))

USERAGENT=$(awk '(NR == '$USERR')' user-agents)
wget -e use_proxy=yes -e http_proxy=127.0.0.1:8118 --header="Accept: text/html" --user-agent="$USERAGENT" -qoO- https://victimsite.com &> /dev/null
sudo systemctl restart tor
sleep $TIMEW
clear
echo $i
done
