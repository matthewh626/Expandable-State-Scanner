#!/usr/bin/env bash
echo "Fetching local network configuration..."
ifOut=$(ifconfig)
if (echo "$ifOut"|grep -q "wlan0");then
        ifOut=$(echo "$ifOut"|grep -A 1 "wlan")
elif (echo "$ifOut"|grep -q "wlp");then
        ifOut=$(echo "$ifOut"|grep -A 1 "wlp")
elif (echo "$ifOut"|grep -q "eth0");then
        ifOut=$(echo "$ifOut"|grep -A 1 "eth0")
elif (echo "$ifOut"|grep -q "enp");then
        ifOut=$(echo "$ifOut"|grep -A 1 "enp")
fi
localIp=$(echo "$ifOut"|grep -E -o "inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
localIp=$(echo "$localIp"|grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
echo "Local ip is: $localIp"
netMask=$(echo "$ifOut"|grep -E -o "netmask [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
netMask=$(echo "$netMask"|grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
echo "Network mask is: $netMask"
cidr=$(ipcalc "$localIp/$netMask"|grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}$")
echo "CDIR format address is: $cidr"
intFace=${ifOut%%:*}
