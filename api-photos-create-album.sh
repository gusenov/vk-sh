#!/bin/bash

# Ключ доступа пользователя:
vk_access_token=""
# Идентификатор идентификатор сообщества, в котором создаётся альбом:
vk_group_id=0

album_title="Название"
album_description="Описание"

path_to_albums_output="VKontakte-albums.json"

# К методам API ВКонтакте (за исключением методов из секций vk.com/dev/secure и vk.com/dev/ads) можно обращаться не чаще 3 раз в секунду. 
time_interval=5

for i in "$@"
do
case $i in
    -g=*|--group_id=*)
    vk_group_id="${i#*=}"
    shift # past argument=value
    ;;
    -t=*|--title=*)
    album_title="${i#*=}"
    shift # past argument=value
    ;;
    -d=*|--description=*)
    album_description="${i#*=}"
    shift # past argument=value
    ;;
    -a=*|--access=*)
    vk_access_token="${i#*=}"
    shift # past argument=value
    ;;
    -o=*|--output=*)
    path_to_albums_output="${i#*=}"
    shift # past argument=value
    ;;
    -i=*|--interval=*)
    time_interval="${i#*=}"
    shift # past argument=value
    ;;
esac
done

if [ ! -f "$path_to_albums_output" ]
then
    echo "{}" > "$path_to_albums_output"
fi

# Список альбомов группы:
vk_albums_in_group=$(curl -s "https://api.vk.com/method/photos.getAlbums?group_id=$vk_group_id&access_token=$vk_access_token")
sleep $time_interval

# Проверка существования альбома:
is_album_exists=$(echo $vk_albums_in_group | jq "[.response|.[]|.title]|contains([\"$album_title\"])")

if $is_album_exists ; then
    # expression evaluated as true
    # echo "[i] Album '$album_title' is already exists."
    :
else
    # expression evaluated as false
    # echo "[!] Album '$album_title' is not exists."

    vk_created_album=$(curl -s "https://api.vk.com/method/photos.createAlbum?group_id=$vk_group_id&access_token=$vk_access_token&upload_by_admins_only=1&comments_disabled=0" \
        --data-urlencode "title=$album_title" \
        --data-urlencode "description=$album_description")
    sleep $time_interval

    cat "$path_to_albums_output" | jq ".+={\"$album_title\":$vk_created_album}" | sponge "$path_to_albums_output"
fi
