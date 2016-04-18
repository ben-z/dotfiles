#!/bin/sh
# File Location: %HOME%/.Xsession
# Script to configure X, start common apps, and start xmonad.
# Modified by: Ben Zhang
# http://github.com/ben-z
# Original Author: Vic Fryzel
# http://github.com/vicfryzel/xmonad-config

STARTUPLOG=/home/ben/.xmonad/startup.log
echo "Startup log" > $STARTUPLOG
echo $(date) >> $STARTUPLOG

# Configure PATH so that we can access our scripts below
PATH=$PATH:~/.cabal/bin:~/.xmonad/bin

# Configure X
echo "xsetroot" >> $STARTUPLOG
xsetroot -cursor_name left_ptr &
echo "xrdb" >> $STARTUPLOG
xrdb -merge ~/.Xdefaults &

# xpmroot ~/background.xpm &

# Start a window compositor. This ensures Google Chrome paints correctly.
echo "xcompmgr" >> $STARTUPLOG
xcompmgr -n &

# Turn off virtual display
xrandr --output VGA-1-1 --off
xrandr --output VGA-1-2 --off

echo "Starting Tray Apps" >> $STARTUPLOG
# Start the system tray
stalonetray &

echo "Starting Network Manager" >> $STARTUPLOG
# Start the network manager
nm-applet --sm-disable &

echo "Starting Clipboard Manager" >> $STARTUPLOG
# Start the clipboard manager
clipit &

echo "Starting Terminals" >> $STARTUPLOG
# Start two terminals
gnome-terminal &
gnome-terminal &

echo "Starting Redshift" >> $STARTUPLOG
# Start RedShift
redshift-gtk -l 43.47:-80.55 &

echo "Starting Browser" >> $STARTUPLOG
# Start a browser
google-chrome &

echo "Starting 1Password Agent" >> $STARTUPLOG
# Start 1Password
/usr/share/playonlinux/playonlinux --run "Agile1pAgent" %F &

echo "Starting Nautilus" >> $STARTUPLOG
# Start Nautilus without a default window
nautilus -n &

echo "Starting Dropbox" >> $STARTUPLOG
# Start Dropbox
dropbox start &

# Start BitTorrent sync
##~/desktop-programs/btsync/btsync --storage ~/.btsync/ &

# Start screensaver
# Kill gnome-screensaver if started by default
# killall gnome-screensaver &
# xscreensaver -no-splash &

# # Start sound server
# pulseaudio --start &

# Fix software installation failures (no password prompt)
# /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

echo "Starting xmonad" >> $STARTUPLOG
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session xmonad
