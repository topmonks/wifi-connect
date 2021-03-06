#!/usr/bin/env bash

export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

# Optional step - it takes couple of seconds (or longer) to establish a WiFi connection
# sometimes. In this case, following checks will fail and wifi-connect
# will be launched even if the device will be able to connect to a WiFi network.
# If this is your case, you can wait for a while and then check for the connection.
sleep 30

# Choose a condition for running WiFi Connect according to your use case:

# 1. Is there a default gateway?
# ip route | grep default

# 2. Is there Internet connectivity?
# nmcli -t g | grep full

# 3. Is there Internet connectivity via a google ping?
# wget --spider http://google.com 2>&1
last4_mac=`cat /sys/class/net/eth0/address | sed 's/://g'`
last4_mac=`echo $last4_mac | tail -c 5`
ssid="$PORTAL_SSID-$last4_mac"


# 4. Is there an active WiFi connection?
iwgetid -r

if [ $? -eq 0 ]; then
    printf 'Skipping WiFi Connect\n'

    #setting connections retries to infinity
    wifi_name=`iwgetid|awk '{split($0,a,"\""); print a[2]}'`
    printf "WIFI hotspot: $wifi_name\n"
    nmcli con mod $wifi_name connection.autoconnect-retries 0
else
    printf 'Starting WiFi Connect\n'
    ./wifi-connect -s $ssid
fi

# Start your application here.
sleep infinity