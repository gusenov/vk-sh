#!/bin/bash

for i in "$@"
do
case $i in
    -g=*|--group_id=*)
    group_id="${i#*=}"
    shift # past argument=value
    ;;
    -t=*|--title=*)
    title="${i#*=}"
    shift # past argument=value
    ;;
    -r=*|--remixsid=*)
    remixsid="${i#*=}"
    shift # past argument=value
    ;;
esac
done

Host="vk.com"
User_Agent="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0"
Accept_Language="en-US,en;q=0.5"
Accept_Encoding="gzip, deflate, br"
Content_Type="application/x-www-form-urlencoded"
X_Requested_With="XMLHttpRequest"
Referer="https://vk.com/albums-$group_id"
Cookie="remixlang=0; remixflash=0.0.0; remixscreen_depth=24; remixdt=10800; remixexp=1; remixsid=$remixsid; remixsslsid=1"
DNT="1"
Connection="keep-alive"

hash=$(
curl -s --data "act=new_album_box&al=1&oid=-$group_id" https://vk.com/al_photos.php \
    --header "Host: $Host" \
    --header "User-Agent: $User_Agent" \
    --header "Accept-Language: $Accept_Language" \
    --header "Accept-Encoding: $Accept_Encoding" \
    --compressed \
    --header "Content-Type: $Content_Type" \
    --header "X-Requested-With: $X_Requested_With" \
    --header "Referer: $Referer" \
    --header "Cookie: $Cookie" \
    --header "DNT: $DNT" \
    --header "Connection: $Connection" \
| pcregrep -o1 "hash: '([a-z0-9]+)'"
)

sleep 1

album_id=$(curl -s --data "act=new_album&al=1&comm=&desc=&hash=$hash&no_redirect=0&oid=-$group_id&only=1&title=$title&view=false" https://vk.com/al_photos.php \
    --header "Host: $Host" \
    --header "User-Agent: $User_Agent" \
    --header "Accept-Language: $Accept_Language" \
    --header "Accept-Encoding: $Accept_Encoding" \
    --compressed \
    --header "Content-Type: $Content_Type" \
    --header "X-Requested-With: $X_Requested_With" \
    --header "Referer: $Referer" \
    --header "Cookie: $Cookie" \
    --header "DNT: $DNT" \
    --header "Connection: $Connection" \
| pcregrep -o1 'album-[0-9]+_([0-9]+)'
)

echo $album_id
