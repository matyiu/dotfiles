#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch bar1 and bar2

if type "xrandr" > /dev/null; then
      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
	if [ $m == 'HDMI-1' ] 
	then		
		MONITOR=$m polybar primary 2>&1 & disown	
	elif [ $m == 'HDMI-0' ]
	then
		MONITOR=$m polybar secondary 2>&1 & disown
	else
		MONITOR=$m polybar primary 2>&1 & disown
	fi
      done
    else
    	polybar primary -c ~/.config/polybar/config &
    fi

echo "Bars launched..."
