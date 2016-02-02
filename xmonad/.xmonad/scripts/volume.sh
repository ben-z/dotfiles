#!/bin/bash
CHANNEL="Master"
MUTED=$(amixer get ${CHANNEL} | egrep -om 1 '\[off\]|\[on\]')

if [[ ${MUTED} == "[off]" ]]; then
  echo '[--[mute]--]'
  exit 0
fi

volume=$(awk -F"[[%]" '/dB/ {print $2}' <(amixer sget ${CHANNEL}))
bars=`expr $volume / 10`

case $bars in
  0)  bar='[----------]' ;;
  1)  bar='[/---------]' ;;
  2)  bar='[//--------]' ;;
  3)  bar='[///-------]' ;;
  4)  bar='[////------]' ;;
  5)  bar='[/////-----]' ;;
  6)  bar='[//////----]' ;;
  7)  bar='[///////---]' ;;
  8)  bar='[////////--]' ;;
  9)  bar='[/////////-]' ;;
  10) bar='[//////////]' ;;
  *)  bar='[----!!----]' ;;
esac

echo $bar

exit 0
