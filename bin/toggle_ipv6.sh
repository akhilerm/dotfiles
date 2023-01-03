#! /bin/bash

# toggle IPV6 on the system

IPV6_DISABLE=$(cat /proc/sys/net/ipv6/conf/all/disable_ipv6)

IPV6_DISABLE=$(( ! $IPV6_DISABLE ))

sudo sysctl -w net.ipv6.conf.all.disable_ipv6=$IPV6_DISABLE
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=$IPV6_DISABLE
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=$IPV6_DISABLE

if [[ $IPV6_DISABLE -eq 0 ]] ; then
	echo "ipv6 enabled"
else
	echo "ipv6 disabled"
fi
