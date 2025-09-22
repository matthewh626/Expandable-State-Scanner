#!/usr/bin/env bash
source ./getNetCfg.sh
nmap -sn "$cidr"
arp -n | grep -v "incomplete" > ../Temp/arpCashe
tail -n +2 ../Temp/arpCashe > ../Temp/arpCashe2
mv ../Temp/arpCashe2 ../Temp/arpCashe
echo "Checking if network is known..."
gatewayIp=$(ip route show | grep 'default' | awk '{print $3}')
gatewayMac=$(cat ../Temp/arpCashe | grep "$gatewayIp " | grep -E -o "[[:xdigit:]:]{17}")
if [ ! -f "../Networks/$gatewayMac" ]; then
	echo "New Network, generating profile stub.."
	echo "Gateway Ip: $gatewayIp" > "../Networks/$gatewayMac"
	echo "Public Ip: $(curl api.ipify.org)" >> "../Networks/$gatewayMac"
	echo "Arp scan:" >> "../Networks/$gatewayMac"
	cat "../Temp/arpCashe" >> "../Networks/$gatewayMac"
else
	echo "Network known, moving on..."
fi
echo "Checking for Device files..."
cat ../Temp/arpCashe | while read line
do
	mac=$(echo "$line" | grep -E -o "[[:xdigit:]:]{17}")
	ip=$(echo "$line" | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
	if [ ! -f "../Devices/$mac" ]; then
		echo "New device $mac found, regestering..."
		echo "last seen at $ip" > "../Devices/$mac"
	else
		echo "Device already seen before, skipping..."
	fi
done
