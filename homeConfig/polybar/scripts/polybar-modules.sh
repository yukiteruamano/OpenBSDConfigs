#!/bin/ksh

_blu="#89b4fa"
_grn="#a6e3a1"
_pch="#fab387"
_red="#f38ba8"

# Nerd Fonts
set -A _bat "%{F$_grn}" "%{F$_pch}" "%{F$_red}"
set -A _pwr "%{F$_blu}"
set -A _lan "%{F$_blu}󰌗" "%{F$_red}󰌗"
set -A _vpn "%{F$_blu}󰌗" "%{F$_pch}󰌗" "%{F$_red}󰌗"
set -A _lan_nic "re0"
set -A _vpn_nic "tun0"
set -A _wg_nic "wg0"
set -A _vol "" "" ""

# Functions ------------------------------------------------------------

function battery {
	[[ $(apm -a) -eq 1 ]] \
	  && echo -n "%{T2}${_pwr[0]}" \
	  || echo -n "%{T2}${_bat[$(apm -b)]}"
	echo -n "%{T-}%{F-} $(apm -l)%"
}

function datetime {
	[[ $(date "+%H") -ge 6 && $(date "+%H") -le 22 ]] \
	  && echo -n "%{F$_red}" \
	  || echo -n "%{F$_red}"
	echo -n $(date '+%a.%e %b. %H:%M ')%{F-}
}

function kbdlayout {
	setxkbmap -query | \
	awk '/^layout:/ { printf "%%\{T2\} %%\{T-\} %s", toupper($2) }'
}

function network {

	CHECK_NET="$(ifconfig ${_lan_nic[0]} | grep 'status: active')"

	if [[ $CHECK_NET != "" ]]; then
		echo -n "LAN:%{T2}${_lan[0]}%{F-}%{T-}"
	else
		echo -n "LAN:%{T2}${_lan[1]}%{F-}%{T-}"
	fi
}

function vpn {

	# OpenVPN
	CHECK_VPN="$(pgrep -fl openvpn | head -n 1| cut -d "/" -f 3 | cut -d "-" -f 1 )"

	# Wireguard VPN
	# ifconfig | grep wg0 | wc -l --> 0 or 1
	CHECK_WG="$(ifconfig | grep ${_wg_nic[0]} | wc -l )"

	# Change connections color
	if [[ $CHECK_VPN == "openvpn" ]]; then
		echo -n "VPN:%{T2}${_vpn[1]}%{F-}%{T-}"
	elif [[ $((CHECK_WG)) == "1" ]]; then
		echo -n "VPN:%{T2}${_vpn[0]}%{F-}%{T-}"
	else
		echo -n "VPN:%{T2}${_vpn[2]}%{F-}%{T-}"
	fi
}

function sensor {
	sysctl -n hw.sensors.ksmn0.temp0 | \
	awk -v warn=$_pch -v alrt=$_red '{
	  if($1 < 60)      { printf "%%\{F-}" }
	  else if($1 < 75) { printf "%%\{F%s}", warn }
	  else             { printf "%%\{F%s}", alrt }
	  { printf "%%\{T2}%%\{T-}%4.0d°C%%\{F-}", $1 }
	}'
}

function memory {
	# Extract data from vmstat in megabytes
	USED_MEM=$( vmstat | tail -1 | awk '{ print $3 }' | sed 's/M//g' )

	# Physical memory
	PHY_MEM=$( sysctl hw.physmem | awk '{print $1}' | sed 's/hw.physmem=//g' )

	# Free memory in gigabytes
	USED_MEM_G=$(echo "scale=2; $USED_MEM / 1024" | bc -l)
	PHY_MEM_G=$(echo "scale=2; $PHY_MEM / (1024*1024*1024)" | bc -l)

	# Total memory in system
	SHOW_MEM="$USED_MEM_G G / $PHY_MEM_G G"
	echo -n "󰍛 Mem: ${SHOW_MEM}"
}

function volume {
	_v=$(sndioctl -n output.level | awk '{ print int($0*100) '})
	[[ $(sndioctl -n output.mute) -eq 1 ]] \
		&& echo -n " " \
		|| echo -n "${_vol[$(($_v*3/101))]} "
	echo -n "$_v%"
}

case $1 in
	"battery") battery;;
	"datetime") datetime;;
	"kbdlayout") kbdlayout;;
	"network") network;;
	"vpn") vpn;;
	"memory") memory;;
	"sensor") sensor;;
	"volume") volume;;
	*)
		echo "You forgot to tell me what to do!"
		exit 1
	;;
esac

exit 0
#EOF
