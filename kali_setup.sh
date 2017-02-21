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
SUBLIME_URL="https://download.sublimetext.com/sublime-text_build-3126_amd64.deb" ## ST3 Build 3126 64 bit
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
printf '  \e[1;34m[+]\e[0m Updating Kali (apt-get update)...'
cmd_exe "apt-get update"

printf '  \e[1;34m[+]\e[0m Removing apt-listchanges...'
cmd_exe "apt-get purge apt-listchanges -y"

printf '  \e[1;34m[+]\e[0m Updating Kali (apt-get upgrade)...'
cmd_exe "apt-get update && apt-get upgrade -y"

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
##   App Installs...    ##
##########################
printf '\e[1;4;94mApp Installs\e[0m\n'
printf '  \e[1;34m[+]\e[0m Installing SSH server...'
cmd_exe "apt-get install -y openssh-server"

printf '  \e[1;34m[+]\e[0m Installing Sublime Text 3...'
cmd_exe "wget -O $HOME/sublime_text_3.deb $SUBLIME_URL && sudo dpkg -i $HOME/sublime_text_3.deb && rm $HOME/sublime_text_3.deb"

##########################
##    Gnome Tweaks...   ##
##########################
printf '\e[1;4;94mGnome Tweaks\e[0m\n'
printf '  \e[1;34m[+]\e[0m Disabling screen lock...'
cmd_exe "gsettings set org.gnome.desktop.lockdown disable-lock-screen true"

printf '  \e[1;34m[+]\e[0m Disabling screensaver...'
cmd_exe "gsettings set org.gnome.desktop.session idle-delay 0"

printf '  \e[1;34m[+]\e[0m Show home icon on desktop...'
cmd_exe "gsettings set org.gnome.nautilus.desktop home-icon-visible true"

printf '  \e[1;34m[+]\e[0m Show trash icon on desktop...'
cmd_exe "gsettings set org.gnome.nautilus.desktop trash-icon-visible true"

printf '  \e[1;34m[+]\e[0m Setting Gnome extentions...'
cmd_exe "gsettings set org.gnome.shell enabled-extensions \"['places-menu@gnome-shell-extensions.gcampax.github.com', 'refresh-wifi@kgshank.net', 'window-list@gnome-shell-extensions.gcampax.github.com', 'apps-menu@gnome-shell-extensions.gcampax.github.com', 'drive-menu@gnome-shell-extensions.gcampax.github.com', 'dash-to-dock@micxgx.gmail.com', 'user-theme@gnome-shell-extensions.gcampax.github.com']\""

printf '  \e[1;34m[+]\e[0m Disabling dash-to-dock autohide...'
cmd_exe "dconf write /org/gnome/shell/extensions/dash-to-dock/dock-fixed true"

printf '  \e[1;34m[+]\e[0m Enabling Nautulus location bar...'
cmd_exe "gsettings set org.gnome.nautilus.preferences always-use-location-entry true"

printf '  \e[1;34m[+]\e[0m Disabling window snapping...'
cmd_exe "gsettings set org.gnome.shell.overrides edge-tiling false"

printf '  \e[1;34m[+]\e[0m Setting favorites bar...'
cmd_exe "dconf write /org/gnome/shell/favorite-apps \"['iceweasel.desktop', 'gnome-terminal.desktop', 'org.gnome.Nautilus.desktop', 'gnome-tweak-tool.desktop', 'sublime_text.desktop', 'gnome-control-center.desktop', 'wireshark.desktop']\""

##########################
##   gedit Tweaks...   ##
##########################
printf '\e[1;4;94mgedit Tweaks\e[0m\n'
printf "  \e[1;34m[+]\e[0m gedit Audo Indent..."
cmd_exe "gsettings set org.gnome.gedit.preferences.editor auto-indent true"

printf "  \e[1;34m[+]\e[0m gedit Highlight Matching Brackets ..."
cmd_exe "gsettings set org.gnome.gedit.preferences.editor bracket-matching true"

printf "  \e[1;34m[+]\e[0m gedit Display Line Numbers..."
cmd_exe "gsettings set org.gnome.gedit.preferences.editor display-line-numbers true"

printf "  \e[1;34m[+]\e[0m gedit Highlight Current Line..."
cmd_exe "gsettings set org.gnome.gedit.preferences.editor highlight-current-line true"

printf "  \e[1;34m[+]\e[0m gedit Tab Size..."
cmd_exe "gsettings set org.gnome.gedit.preferences.editor tabs-size 4"

##########################
##   System Tweaks...   ##
##########################
printf '\e[1;4;94mSystem Tweaks\e[0m\n'
printf '  \e[1;34m[+]\e[0m 12 hour time...'
cmd_exe "gsettings set org.gnome.desktop.interface clock-format '12h'"

printf '  \e[1;34m[+]\e[0m Changing time zone...'
cmd_exe "echo $TIMEZONE > /etc/timezone && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && dpkg-reconfigure -f noninteractive tzdata"

printf '  \e[1;34m[+]\e[0m Disabling super key...'
cmd_exe "gsettings set org.gnome.mutter overlay-key ''"

printf '  \e[1;34m[+]\e[0m Creating text file template...'
cmd_exe "touch $HOME/Templates/New\ Text\ File.txt"

printf '  \e[1;34m[+]\e[0m Setting caps lock as control...'
cmd_exe "gsettings set org.gnome.desktop.input-sources xkb-options \"['ctrl:nocaps']\""

printf '  \e[1;34m[+]\e[0m Disabling IPv6...'
cmd_exe "echo -e '# IPv6 disabled\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.conf && sysctl -p"

printf '  \e[1;34m[+]\e[0m Setting ST3 as default...'
cmd_exe "cp resources/defaults.list $HOME/.local/share/applications/defaults.list"

# Testing
## Completely Disable network-manager
# printf '   \e[1;34m[+]\e[0m Disabling network-manager service...'
# cmd_exe "systemctl stop NetworkManager.service && systemctl disable NetworkManager.service"

# Testing
## Disable only on wlan(0..12)mon interfaces
# printf '   \e[1;34m[+]\e[0m Disabling network-manager on wlan interfaces...'
# cmd_exe "echo -e '\n[keyfile]\nunmanaged-devices=interface-name:wlan0mon;interface-name:wlan1mon;interface-name:wlan2mon;interface-name:wlan3mon;interface-name:wlan4mon;interface-name:wlan5mon;interface-name:wlan6mon;interface-name:wlan7mon;interface-name:wlan8mon;interface-name:wlan9mon;interface-name:wlan10mon;interface-name:wlan11mon;interface-name:wlan12mon' >> /etc/NetworkManager/NetworkManager.conf"

##########################
##     Eye Candy...     ##
##########################
printf '\e[1;4;94mEye Candy\e[0m\n'
printf '  \e[1;34m[+]\e[0m Installing powerline for tmux...'
cmd_exe "apt-get install powerline -y && git clone https://github.com/powerline/fonts.git && fonts/install.sh && rm -rf fonts/"

printf '  \e[1;34m[+]\e[0m Changing gnome-terminal profile...'
cmd_exe "dconf load /org/gnome/terminal/legacy/profiles:/ < resources/monokai-soda.xml"
# Use `dconf dump /org/gnome/terminal/legacy/profiles:/ > ~/Desktop/monokai-soda.xml` to export the current gnome-terminal settings.

##########################
##    Setup configs...  ##
##########################
printf '\e[1;4;94mConfigs\e[0m\n'
printf '  \e[1;34m[+]\e[0m Configuring Sublime Text...'
cmd_exe "rm -rf $HOME/.config/sublime-text-3/Packages/User/ && git clone https://github.com/scott-be/Sublime-Text-3-Settings.git $HOME/.config/sublime-text-3/Packages/User/"

printf '  \e[1;34m[+]\e[0m Setting up dotfiles (mc, bash, tmux, vim, etc.)...'
cmd_exe "cd $HOME && rm -rf && git clone https://github.com/scott-be/dotfiles.git && bash dotfiles/make.sh --linux && cd -"

##########################
##     Other stuff...   ##
##########################
printf '\e[1;4;94mOther Stuff\e[0m\n'
printf '  \e[1;34m[+]\e[0m Setting up metasploit...'
cmd_exe "/etc/init.d/postgresql start && msfdb init"

#=~=~=~=~=~=~=~=~=~=~=~=~#
## TODO
# [ ] Download scripts (macsoof.sh, update_git_repos.sh)