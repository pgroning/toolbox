#!/bin/bash

### A stab at fixing Pulse Audio settings when you find your Mint has gone mute ...
### version 1.0 - 2012-09-28
###
### The most common problem is that the audio sink defaults to the HDMI on my laptop.
### As such, you will see "grep" statements at the end of "ASINK" and "ASOURCE" lines.
### Run the script without modification, first - you will get a list of audio "sinks"
### (aka outputs) and "sources" (aka inputs). If you can tell which ones you would
### like to use on a regular basis, modify the part of the line AFTER the "awk"
### statement to specify them.

# List audio sinks (outputs)
echo Avalable sinks:
pacmd list-sinks | grep name:

# Replace to the right of the marker to specify your audio sinks (outputs)         \/
ASINK=`pacmd list-sinks | grep name: | awk ' { print substr($2,2,length($2)-2) } ' | grep hdmi`
#ASINK=`pacmd list-sinks | grep name: | awk ' { print substr($2,2,length($2)-2) } ' | grep analog`
echo Default sink set to $ASINK
pacmd set-default-sink $ASINK
echo
pacmd set-sink-volume $ASINK 33000
#pacmd set-sink-volume $ASINK 65000
echo
echo ------------------------------

# List audio sources (inputs)
echo Available sources:
pacmd list-sources | grep name:

# Replace to the right of the marker to specify your audio sources (inputs)            \/
ASOURCE=`pacmd list-sources | grep name: | awk ' { print substr($2,2,length($2)-2) } ' | grep hdmi`
#ASOURCE=`pacmd list-sources | grep name: | awk ' { print substr($2,2,length($2)-2) } ' | grep -v monitor | grep analog`
echo Default source set to $ASOURCE
pacmd set-default-source $ASOURCE
echo
pacmd set-source-volume $ASOURCE 33000
#pacmd set-source-volume $ASOURCE 65000
echo
