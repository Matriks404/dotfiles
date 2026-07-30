#!/bin/sh

. ~/.profile

xrdb -load .Xresources
setxkbmap -option caps:swapescape

xterm -geometry 80x32+16+16 &
xclock -digital -render -padding 1 -bg black -fg white -geometry -98-3 &

exec fvwm
