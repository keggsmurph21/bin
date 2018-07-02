#!/bin/bash -e

cache=/tmp/vplay

mkdir -p $cache

i=0
for path in "$@"; do
  echo " - writing $path to vplay cache" >&2
  cp -r "${path%/}" $cache 2>/dev/null || :
  paths[$i]="$cache/$(basename "$path")"
  ((i++))
done
echo " => all files written to cache :)" >&2

vlc "${paths[@]}" --global-key-play-pause F8 --global-key-next F9 --global-key-prev F7 2>/dev/null
