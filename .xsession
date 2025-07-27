#!/bin/sh

xrdb -load .Xresources

xterm -geometry 80x32+16+16 -e bash &
xclock -geometry -16+16 &

exec fvwm
