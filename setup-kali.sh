#!/usr/bin/env bash

##########################
##      Functions       ##
##########################
cmd_exe () {
	eval $@ >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		printf "[\033[32mOK\033[0m]\n"
	else
		printf "[\033[31mFAIL\033[0m]\n"
	fi
}

##########################
##      Variables       ##
##########################
TIMEZONE="America/New_York"

##########################
##   Change Password    ##
##########################
printf '\e[1;4;94mSetup\e[0m\n'
CURRENT_PASS=`grep -w root /etc/shadow | cut -d: -f2`
export SALT=`grep -w root /etc/shadow | cut -d$ -f3`
GENPASS=$(perl -le 'print crypt("toor","\$6\$$ENV{SALT}\$")')
if [ $GENPASS == $CURRENT_PASS ]; then
	printf '  \e[1;34m[+]\e[0m Change password...\n'
	passwd
fi
##########################
##  Regenerate SSH keys ##
##########################
read -p $'  \e[1;34m[>]\e[0m Regenerate SSH keys?...(Y/n)' -r
if [[ $REPLY == "Y" || $REPLY == "y" || -z $REPLY ]]; then
	printf '  \e[1;34m[+]\e[0m Regenerating keys...'
    cmd_exe "rm /etc/ssh/ssh_host_* && dpkg-reconfigure openssh-server"
fi
##########################
##      Update Kali     ##
##########################
printf '  \e[1;34m[+]\e[0m Updating Kali (apt update)...'
cmd_exe "apt update"

printf '  \e[1;34m[+]\e[0m Removing apt-listchanges...'
cmd_exe "apt purge apt-listchanges -y"

printf '  \e[1;34m[+]\e[0m Upgrading Kali (apt upgrade)...'
cmd_exe "apt update && apt upgrade -y"

##########################
##    Change Hostname   ##
##########################
if [ $HOSTNAME == "kali" ]; then 
	printf '  \e[1;34m[+]\e[0m Change hostname...\n'
	OLD_HOSTNAME="$(hostname)"
	printf '  \e[1;34m[>]\e[0m Enter new hostname: '
	read NEW_HOSTNAME
	hostnamectl set-hostname $NEW_HOSTNAME
	sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts
	/etc/init.d/hostname.sh start
	service networking force-reload
	service network-manager force-reload
fi

##########################
##     Other stuff...   ##
##########################
printf '\e[1;4;94mOther Stuff\e[0m\n'
printf '  \e[1;34m[+]\e[0m Setting up metasploit...'
cmd_exe "/etc/init.d/postgresql start && msfdb init"

##########################
##     Other Scripts    ##
##########################
read -p $'  \e[1;34m[>]\e[0m Run setup-gnome.sh?...(Y/n)' -r
if [[ $REPLY == "Y" || $REPLY == "y" || -z $REPLY ]]; then
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	"$DIR/setup-gnome.sh"
fi

read -p $'  \e[1;34m[>]\e[0m Run install-applications-kali.sh?...(Y/n)' -r
if [[ $REPLY == "Y" || $REPLY == "y" || -z $REPLY ]]; then
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	"$DIR/install-applications-kali.sh"
fi

#=~=~=~=~=~=~=~=~=~=~=~=~#
## TODO
# [ ] Download scripts (macsoof.sh, update_git_repos.sh)

# Testing
## Completely Disable network-manager
# printf '   \e[1;34m[+]\e[0m Disabling network-manager service...'
# cmd_exe "systemctl stop NetworkManager.service && systemctl disable NetworkManager.service"

# Testing
## Disable only on wlan(0..12)mon interfaces
# printf '   \e[1;34m[+]\e[0m Disabling network-manager on wlan interfaces...'
# cmd_exe "echo -e '\n[keyfile]\nunmanaged-devices=interface-name:wlan0mon;interface-name:wlan1mon;interface-name:wlan2mon;interface-name:wlan3mon;interface-name:wlan4mon;interface-name:wlan5mon;interface-name:wlan6mon;interface-name:wlan7mon;interface-name:wlan8mon;interface-name:wlan9mon;interface-name:wlan10mon;interface-name:wlan11mon;interface-name:wlan12mon' >> /etc/NetworkManager/NetworkManager.conf"
