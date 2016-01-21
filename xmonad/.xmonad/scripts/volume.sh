#!/usr/bin/env bash
# encoding: utf-8

ACCENT_COLOR="#FFDD00"
OFF_COLOR="#cb4b16"
THRESHOLD="79"

# Choose channel and device preferences based on host name.
# if [[ $(hostname) == "zion" ]]; then
#     CHANNEL="Master"
# fi
CHANNEL="Master"
# echo "${CHANNEL}"

VOLUME=$(amixer get ${CHANNEL} | egrep -om 1 "\[[[:digit:]]+%\]")
VOLUME_VALUE=$(sed "s/[^0-9]//g" <<< "${VOLUME}")
MUTED=$(amixer get ${CHANNEL} | egrep -om 1 '\[off\]|\[on\]')

if [[ ${MUTED} == "[off]" ]]; then
    echo "<fc=${OFF_COLOR}>${VOLUME_VALUE}% </fc>"
else
    if (( VOLUME_VALUE > THRESHOLD )); then
        echo "<fc=${ACCENT_COLOR}>${VOLUME_VALUE}% </fc>"
    else
        # Extra whitespace fixes `%` symbol corruption
        echo "${VOLUME_VALUE}% "
    fi
fi
