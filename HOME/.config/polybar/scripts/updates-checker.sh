#!/usr/bin/env bash

set -e -o pipefail

eval $(cat $HOME/.config/polybar/colors.ini | rg '^[a-z]+ = #[0-9a-fA-F]+$' | tr -d ' ' | sed -r 's#^#color_#g')

DIR=/tmp/polybar/updates
mkdir -p $DIR

function cleanUp() {
  sudo rm $DIR/check &> /dev/null
}

trap cleanUp EXIT

function interval() {
  [[ $(( $(date +%s) % $1 )) == 0 ]]
}

function update() {
  timeout 20 /bin/yay -Syy &>/dev/null &
  FLATPATK_UPDATES=$(timeout 20 flatpak remote-ls --updates 2> /dev/null | wc -l)
  wait
  UPDATES=$(yay -Qu --repo 2>/dev/null | wc -l)
  AUR_UPDATES=$(yay -Qu --aur --devel 2> /dev/null | wc -l)
  if (( (UPDATES + AUR_UPDATES + FLATPATK_UPDATES) >= 1 )) && ! pgrep -x yay &> /dev/null && ! pgrep -x flatpak &> /dev/null
  then
    notify-send.sh -t 10000 -R $DIR/NOTIFICATION_ID -u critical "$(BAR_ICON) $UPDATES | $AUR_UPDATES | $FLATPATK_UPDATES $(BAR_ICON)"
    i3-msg exec "i3-sensible-terminal -- sh -c 'yay -Syu --devel --noconfirm --removemake --combinedupgrade --batchinstall && flatpak update --assumeyes'"
  fi
  echo
}

update
while true
do
  until interval 60
  do
    if [ -e $DIR/check ]
    then
      sudo rm -f $DIR/check &> /dev/null
      update
    fi
    sleep 1
  done
  update
done
