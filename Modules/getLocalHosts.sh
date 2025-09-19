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
nmap -sn "$cidr"
arp -n | grep -v "incomplete" > ../Temp/arpCashe
tail -n +2 ../Temp/arpCashe > ../Temp/arpCashe2
mv ../Temp/arpCashe2 ../Temp/arpCashe
echo "Checking if network is known..."
gatewayIp=$(ip route show | grep 'default' | awk "{print $3}")
gatewayMac=$(cat ../Temp/arpCashe | grep "$gatewayIp" | grep -E -o "[[:xdigit:]:]{17}")
if [ ! -f "../Networks/$gatewayMac"]; then
	echo "New Network, generating profile stub.."
	echo "Gateway Ip: $gatewayIp" > "../Networks/$gatewayMac"
	echo "Public Ip: $(curl api.ipify.org)" >> "../Networks/$gatewayMac"
	echo "Arp scan:" >> "../Networks/$gatewayMac"
	cat "../Temp/arpCashe" >> "../Networks/$gatewayMac"

#echo "Checking for Device files..."
#cat ../Temp/arpCashe | while read line
#do
#	mac = $(echo "$line" | grep -o -i "[0-9a-f]\{12\}"
#	ip = $(echo "$line" | grep -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"
#	if [ ! -f "../Devices/$mac"]; then
#		echo "last seen at "
#
