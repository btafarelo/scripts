#/bin/bash

. /home/pi/scripts/cloudflare-ddns-update-config.sh

myip=$(bash /home/pi/scripts/zte-f680-myip.sh)

if [ "$lastip" = "$myip" ]; then
	exit 0;
fi

lastip=$myip

sed -i 's/lastip=.*/lastip='$lastip'/g' /home/pi/scripts/cloudflare-ddns-update-config.sh

curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records/$entryId" -H "X-Auth-Email: $email" -H "X-Auth-Key: $authkey" -H "Content-Type: application/json" --data '{"type":"A","name":"'$domain'","content":"'$myip'","proxied":true}'
