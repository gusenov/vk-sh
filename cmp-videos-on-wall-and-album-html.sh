#!/bin/bash

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
    -f=*|--file=*)
      output_file="${i#*=}"
      [ -f "$output_file" ] && rm "$output_file"
      shift # past argument=value
      ;;
  esac
done

wall_videos=$(./all-videos-from-wall.sh --owner_id="$owner_id" --access_token="$access_token")
wall_videos_len=$(echo "$wall_videos" | jq 'length')

album_videos=$(./all-album-videos.sh --owner_id="$owner_id" --access_token="$access_token")
album_videos_len=$(echo "$album_videos" | jq 'length')

cat << EOF >> "$output_file"
<!DOCTYPE html>
<html>
<head>
<title></title>
<style>
  .cut-text {
    height: 1.2em;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    width: 700px;
  }

  table {
    border-collapse: collapse;
    table-layout: auto;
    width: 100%;
  }

  td {
    white-space: nowrap;
  }
</style>
</head>
<body>
<table border="1" cellpadding="10" cellspacing="10">
  <thead>
    <tr>
      <th>#</th>
      <th>title and link</th>
      <th>duration<br/>hh : mm : ss</th>
      <th>views</th>
      <th>already</th>
    </tr>
  </thead>
  <tbody>
EOF

for (( i=0; i<wall_videos_len; i++ )); do
  echo -n "$i of $wall_videos_len, "

  wall_video=$(echo "$wall_videos" | jq ".[$i]")
  #echo "$wall_video"

  vid=$(echo "$wall_video" | jq --raw-output ".vid")
  owner_id=$(echo "$wall_video" | jq --raw-output ".owner_id")
  title=$(echo "$wall_video" | jq --raw-output ".title")
  description=$(echo "$wall_video" | jq --raw-output ".description" | sed -e 's/<br>/ /g')
  duration=$(echo "$wall_video" | jq --raw-output ".duration")
  #link=$(echo "$wall_video" | jq --raw-output ".link")
  link="https://vk.com/video${owner_id}_$vid"
  #echo "$link"
  views=$(echo "$wall_video" | jq --raw-output ".views")
  #player=$(echo "$wall_video" | jq --raw-output ".player")

  #exit

  is_wall_video_in_album=$(echo "$album_videos" | jq ". | any(.vid == $vid)")
  if [[ "$is_wall_video_in_album" == "true" ]]; then
    already="✔"
  else
    already=""
  fi

  cat << EOF >> "$output_file"
    <tr>
      <td>$((i + 1))</td>
      <td><div class="cut-text"><b><a href="$link">$title</a></b></div><div class="cut-text"><i>$description</i></div></td>
      <td>$((duration / 60 / 60)) : $((duration / 60 % 60)) : $((duration % 60))</td>
      <td>$views</td>
      <td>$already</td>
    </tr>
EOF

  #break
done

cat << EOF >> "$output_file"
  </tbody>
  <tfoot>
  </tfoot>
</table>
</body>
</html>
EOF
