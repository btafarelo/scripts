#!/bin/bash

user=1234
pass=1234
cookie=zte-f680-cookie.txt

token=$(curl -b $cookie -c $cookie -s 'http://192.168.1.1/' -H @zte-f680-headers.txt --compressed | grep "\"Frm_Logintoken\"" | grep -o "[0-9]*")

curl -b $cookie -c $cookie -s 'http://192.168.1.1/' -H @zte-f680-headers.txt -H 'Referer: http://192.168.1.1/' -H 'Content-Type: application/x-www-form-urlencoded' --data "frashnum=&action=login&Frm_Logintoken=$token&Username=$user&Password=$pass" --compressed > /dev/null

session_token=$(curl -b $cookie -c $cookie -s 'http://192.168.1.1/getpage.gch?pid=1002&nextpage=status_dev_info_t.gch' -H @zte-f680-headers.txt -H 'Referer: http://192.168.1.1/start.ghtml' --compressed | grep "session_token = \"[0-9]*\"" | grep -o "[0-9]*")

ip=$(curl -b $cookie -c $cookie -s 'http://192.168.1.1/getpage.gch?pid=1002&nextpage=IPv46_status_wan_if_t.gch' -H @zte-f680-headers.txt -H 'Content-Type: application/x-www-form-urlencoded' -H 'Referer: http://192.168.1.1/getpage.gch?pid=1002&nextpage=status_dev_info_t.gch' --data "IF_ACTION=devrestart&IF_ERRORSTR=SUCC&IF_ERRORPARAM=SUCC&IF_ERRORTYPE=-1&flag=1&_SESSION_TOKEN=$session_token" --compressed | grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*/255\.[0-9]*\.[0-9]*\.[0-9]*")

rm $cookie

echo ${ip/\/*/}
