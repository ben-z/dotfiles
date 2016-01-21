#!/bin/bash

# Load resources

# xrdb -merge .Xresources

# # Set up an icon tray
# stalonetray &
#
# # Fire up apps
#
# # xscreensaver -no-splash &
#
# if [ -x /usr/bin/nm-applet ] ; then
#    nm-applet --sm-disable &
# fi
#
# drobox start

exec xmonad
