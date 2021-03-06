#!/usr/bin/env sh

location=${1:?Must provice location: top/bottom}

set -exu

for MONITOR in $(polybar -m | cut -d: -f1)
do
  # Launch bar1 and bar2
  if polybar -m | grep $MONITOR | grep primary &>/dev/null
  then
    export TRAY=right
  else
    export TRAY=none
  fi
  export MONITOR
  polybar $location -c $XDG_CONFIG_HOME/polybar/config-$location.ini &
done
