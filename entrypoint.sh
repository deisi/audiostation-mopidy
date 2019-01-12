#!/bin/bash

if [ ! -f "/etc/mopidy/mopidy.conf" ]
then
    cp /etc/default/mopidy.conf  /etc/mopidy/mopidy.conf
fi

if [ -z "$PULSE_COOKIE_DATA" ]
then
    echo -ne $(echo $PULSE_COOKIE_DATA | sed -e 's/../\\x&/g') >$HOME/pulse.cookie
    export PULSE_COOKIE=$HOME/pulse.cookie
fi

mopidy --config /etc/mopidy/mopidy.conf
