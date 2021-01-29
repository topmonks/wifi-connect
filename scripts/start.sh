**#!/usr/bin/env bash**

export DBUS\_SYSTEM\_BUS\_ADDRESS=unix:path=/host/run/dbus/system\_bus\_socket

_# Optional step - it takes couple of seconds (or longer) to establish a WiFi connection
# sometimes. In this case, following checks will fail and wifi-connect
# will be launched even if the device will be able to connect to a WiFi network.
# If this is your case, you can wait for a while and then check for the connection._
sleep 15

_# Choose a condition for running WiFi Connect according to your use case:_

_# 1. Is there a default gateway?
# ip route | grep default_

_# 2. Is there Internet connectivity?
# nmcli -t g | grep full_

_# 3. Is there Internet connectivity via a google ping?
# wget --spider http://google.com 2>&1_

last4\_mac=`cat /sys/class/net/eth0/address | sed **'s/://g'**`
last4\_mac=`echo $last4\_mac | tail -c 5`
ssid=**"**$PORTAL\_SSID**-**$last4\_mac**"****


**_# 4. Is there an active WiFi connection?_
iwgetid -r

**if** [ $? -eq 0 ]; **then**
    printf **'Skipping WiFi Connect\\n'
else**
    printf **'Starting WiFi Connect\\n'**
    ./wifi-connect -s $ssid
**fi**

_# Start your application here._
sleep infinity

