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

# Start a window compositor. This ensures Google Chrome paints correctly.
echo "xcompmgr" >> $STARTUPLOG
xcompmgr -n &

# Turn off virtual display
xrandr --output VGA-1-1 --off

echo "Starting Tray Apps" >> $STARTUPLOG
# Start the system tray
stalonetray &

# Start the network manager
nm-applet --sm-disable &

# Start the clipboard manager
clipit &

# Start two terminals
gnome-terminal &
gnome-terminal &

# Start RedShift
redshift-gtk -l 43.47:-80.55 &

# Start a browser
google-chrome &

# Start 1Password
/home/ben/.wine/drive_c/Program\ Files\ \(x86\)/1Password\ 4/Agile1pAgent.exe &

# Start Dropbox
dropbox start &

# Start BitTorrent sync
##~/desktop-programs/btsync/btsync --storage ~/.btsync/ &

# Start screensaver
# Kill gnome-screensaver if started by default
killall gnome-screensaver &
xscreensaver -no-splash &

# # Start sound server
# pulseaudio --start &

/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

exec ck-launch-session dbus-launch --sh-syntax --exit-with-session xmonad
