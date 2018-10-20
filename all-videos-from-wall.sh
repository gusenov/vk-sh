#!/bin/bash


function get_list_of_posts_on_a_community_wall() {
  local owner_id="$1"
  local count="$2"
  local offset="$3"
  local access_token="$4"

  curl --silent "https://api.vk.com/method/wall.get?owner_id=-$owner_id&count=$count&offset=$offset&access_token=$access_token&version=5.87"
}

function get_list_of_all_posts_on_a_community_wall() {
  local owner_id="$1"
  local access_token="$2"

  local count=100  # положительное число, максимальное значение 100.
  local offset=1
  local list_of_posts_on_a_community_wall=$(get_list_of_posts_on_a_community_wall "$owner_id" "$count" "$offset" "$access_token")
  local result=$(echo "$list_of_posts_on_a_community_wall" | jq '.response[1:][]')

  #echo "$list_of_posts_on_a_community_wall" | jq '.'
  #echo "$list_of_posts_on_a_community_wall" | jq '.response | length'
  #echo "$list_of_posts_on_a_community_wall" | jq '.response[1:]'
  #exit

  offset=$((offset+count))

  local total=$(echo "$list_of_posts_on_a_community_wall" | jq '.response[0]')

  for (( c=1; c<=total/count-1; c++ )); do
    list_of_posts_on_a_community_wall=$(
      get_list_of_posts_on_a_community_wall "$owner_id" "$count" "$offset" "$access_token"
    )
    #echo "$list_of_posts_on_a_community_wall" | jq '.response | length'

    result+=$(echo "$list_of_posts_on_a_community_wall" | jq '.response[1:][]')

    offset=$((offset+count))
  done

  count=$(($total%count))
  if (( count > 0 )); then
    list_of_posts_on_a_community_wall=$(get_list_of_posts_on_a_community_wall "$owner_id" "$count" "$offset" "$access_token")
    #echo "$list_of_posts_on_a_community_wall" | jq '.response | length'

    result+=$(echo "$list_of_posts_on_a_community_wall" | jq '.response[1:][]')
  fi

  echo "$result" | jq --slurp '.' | jq 'sort_by(.id)'
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

all_posts_on_a_community_wall=$(get_list_of_all_posts_on_a_community_wall "$owner_id" "$access_token")
#echo "$all_posts_on_a_community_wall" | jq 'length'

echo "$all_posts_on_a_community_wall" | jq '.[] | .attachments[] | select(.type == "video") | .video' | jq --slurp '.' | jq 'unique_by(.vid)'




# Ниже под порядком (№) подразумевается способ отображения постов на стене,
# сверху вниз как они расположены в пользовательском интерфейсе,
# при открытии стене.
# Т.е. по умолчанию последний добавленный пост становится на позицию № 1.

# ___№1___    ___№2___    ___№3___    ___№4___    ___№5___    ___№6___
# offset=1    offset=2    offset=3    offset=4    offset=5    offset=6

# |______|
# offset=1
# count=1

# |__________________|
# offset=1
# count=2

#                         |__________________|
#                         offset=3
#                         count=2
