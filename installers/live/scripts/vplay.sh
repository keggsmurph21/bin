#!/bin/sh -e

cache=/tmp/vplay

if [ ! -d $cache ]; then
  mkdir -p $cache
fi

i=0
for path in "$@"; do
  echo "writing $path to vplay cache"
  cp -r "${path%/}" $cache
  paths[$i]="$cache/$(basename "$path")"
  ((i++))
done

vlc "${paths[@]}" --global-key-play-pause F8 --global-key-next F9 --global-key-prev F7 2>/dev/null
