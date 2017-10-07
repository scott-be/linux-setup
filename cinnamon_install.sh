#!/usr/bin/env bash
# Author: Scott Bernstein - https://github.com/scott-be
# Changelog:
#   2017-20-02 - Init
#   2017-07-04 - Split install_cinnamon.sh into two files (install and setup)
#   2017-10-06 - Removed the nemo restat. No workie workie.

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
##   Cinnamon Install   ##
##########################
printf '\e[1;4;94mCinnamon Install\e[0m\n'
printf '  \e[1;34m[+]\e[0m Install Cinnamon...'
cmd_exe "apt-get install -y cinnamon cinnamon-desktop-environment"

printf '  \e[1;34m[+]\e[0m Set Cinnamon as default...\n'
echo cinnamon-session > /root/.xsession
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set org.nemo.desktop show-desktop-icons true
# update-alternatives --config x-session-manager

printf '  \e[1;34m[+]\e[0m Copy patched nemo...'
cmd_exe "cp resources/nemo /usr/local/bin/nemo"

# printf '  \e[1;34m[+]\e[0m Restart nemo...'
# cmd_exe "nemo -q && nemo -n"