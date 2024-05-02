#!/bin/sh

rm /tmp/dns-log.txt
exec >> /tmp/dns-log.txt
IP=$(curl https://ipinfo.io/ip)
echo "Current IP is $IP"

TOKEN="YOUR_TOKEN"
ZONE_ID="ZONE_ID"
RECORD_ID="RECORD_ID"

API="https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID"
CF_RAW=$(curl -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" $API)
CF_IP=$(echo $CF_RAW | grep -o '"content":"[^"]*' | grep -o '[^"]*$')

echo "$CF_IP"

if [ "$IP" != "$CF_IP" ]
then
    echo "Current IP does not match DNS record!"
    PAYLOAD_RAW='{"type":"A","name":"jf","content":"%s"}'
    PAYLOAD=$(printf "$PAYLOAD_RAW" "$IP")
    echo "$PAYLOAD"
    CF_UPDATE=$(curl -X PATCH -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -H "X-Auth-Email: zac927@live.com" $API --data $PAYLOAD)
    echo "$CF_UPDATE"
else
    echo "Current IP matches DNS record"
    exit 0
fi