#!/bin/bash
set -eux -o pipefail

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

function stop() {
	sysctl net.ipv4.ip_forward=0
	pkill hostapd
	ifconfig uap0 down
	service dnsmasq stop
}

function start() {
	ifconfig uap0 || \
		iw dev wlan0 interface add uap0 type __ap

	service dnsmasq restart
	sysctl net.ipv4.ip_forward=1
	iptables -t nat -A POSTROUTING -s 10.13.81.0/24 ! -d 10.13.81.0/24 -j MASQUERADE
	ifup uap0
	hostapd /etc/hostapd/hostapd.conf
}

if [[ "$1" == "start" ]]; then
	start
elif [[ "$1" == "stop" ]]; then
	stop
fi
