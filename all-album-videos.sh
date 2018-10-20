#!/bin/bash

# Для получения токена надо открыть страницу по адресу:
# https://oauth.vk.com/authorize?client_id=5791134&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=video&response_type=token&v=5.87
# Число 5791134 в адресе - это ID приложения vk-sh (https://vk.com/app5791134).

function get_list_of_videos() {
  local owner_id="$1"
  local count="$2"
  local offset="$3"
  local access_token="$4"

  curl --silent "https://api.vk.com/method/video.get?owner_id=-$owner_id&count=$count&offset=$offset&access_token=$access_token&version=5.87"
}

function get_list_of_all_videos() {
  local owner_id="$1"
  local access_token="$2"

  local count=200  # положительное число, максимальное значение 200, по умолчанию 100.
  local offset=0
  local list_of_videos=$(get_list_of_videos "$owner_id" "$count" "$offset" "$access_token")
  local result=$(echo "$list_of_videos" | jq '.response[1:][]')

  #echo "$list_of_videos" | jq '.'
  #echo "$list_of_videos" | jq '.response | length'
  #echo "$list_of_videos" | jq '.response[1:]'
  #exit

  offset=$((offset+count))

  local total=$(echo "$list_of_videos" | jq '.response[0]')

  for (( c=1; c<=total/count-1; c++ )); do
    list_of_videos=$(
      get_list_of_videos "$owner_id" "$count" "$offset" "$access_token"
    )
    #echo "$list_of_videos" | jq '.response | length'

    result+=$(echo "$list_of_videos" | jq '.response[1:][]')

    offset=$((offset+count))
  done

  count=$(($total%count))
  if (( count > 0 )); then
    list_of_videos=$(get_list_of_videos "$owner_id" "$count" "$offset" "$access_token")
    #echo "$list_of_videos" | jq '.response | length'

    result+=$(echo "$list_of_videos" | jq '.response[1:][]')
  fi

  echo "$result" | jq --slurp '.' | jq 'unique_by(.vid)'
}

for i in "$@"; do
  case $i in
    -o=*|--owner_id=*)
      owner_id="${i#*=}"
      shift # past argument=value
      ;;
    -a=*|--access_token=*)
      access_token="${i#*=}"
      shift # past argument=value
      ;;
  esac
done

all_videos=$(get_list_of_all_videos "$owner_id" "$access_token")
#echo "$all_videos" | jq 'length'
echo "$all_videos"




# Ниже под порядком (№) подразумевается способ отображения видеозаписей
# в соответствующем им разделе,
# сверху вниз как они расположены в пользовательском интерфейсе,
# при открытии раздела.
# Т.е. по умолчанию последняя добавленная видеозапись становится на позицию № 1.

# ___№1___    ___№2___    ___№3___    ___№4___    ___№5___    ___№6___
# offset=0    offset=1    offset=2    offset=3    offset=4    offset=5

# |______|
# offset=0
# count=1

# |__________________|
# offset=0
# count=2

#                         |__________________|
#                         offset=2
#                         count=2
