#!/bin/sh

set -ex

xrandr --output eDP-1-1 --mode 1920x1080 --pos 2560x0 --rotate normal --output DP-1-1 --off --output HDMI-1-1 --primary --mode 2560x1080 --pos 0x0 --rotate normal --output DP-1-2 --off --output HDMI-1-2 --off
