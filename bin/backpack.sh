#!/bin/bash
set -eux -o pipefail

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

function stop() {
    pushd /var/www/BackpackPi
    make stop_django
    popd

	sysctl net.ipv4.ip_forward=0
	pkill hostapd
	ifconfig uap0 down
	service dnsmasq stop
}

function start() {
    pushd /var/www/BackpackPi
    make start_django
    popd

	ifconfig uap0 || \
		iw dev wlan0 interface add uap0 type __ap

	service dnsmasq start
	sysctl net.ipv4.ip_forward=1
	iptables -t nat -A POSTROUTING -s 10.13.81.0/24 ! -d 10.13.81.0/24 -j MASQUERADE
	ifup uap0
	hostapd /etc/hostapd/backpack.conf
}

if [[ "$1" == "start" ]]; then
	start
elif [[ "$1" == "stop" ]]; then
	stop
fi
