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

install_powerline () {
	apt-get install powerline -y
	echo "source '/usr/share/powerline/bindings/tmux/powerline.conf'" >> .tmux.conf
	git clone https://github.com/powerline/fonts.git && fonts/install.sh && rm -rf fonts/
	return 0
}

##########################
##      Variables       ##
##########################
SUBLIME_URL="http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb"
TIMEZONE="America/New_York"

##########################
## First things first...##
##########################
chage -l root | grep 'Aug 10, 2015' &> /dev/null # Check if root PW has been changed
if [ $? -eq 0 ]; then
	printf '[+] Change password...\n'
	passwd
fi

printf '[+] Updating Kali...'
cmd_exe "apt-get update && apt-get upgrade -y"

if [ $HOSTNAME = "kali" ]; then 
	printf '[+] Change hostname...\n'
	OLD_HOSTNAME="$(hostname)"
	echo 'Enter new hostname:'
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
printf '[+] Installing SSH server...'
cmd_exe "apt-get install -y openssh-server"

printf '[+] Installing Sublime Text 3...'
cmd_exe "wget -O $HOME/sublime_text_3.deb $SUBLIME_URL && sudo dpkg -i $HOME/sublime_text_3.deb && rm $HOME/sublime_text_3.deb"

printf '[+] Installing Chromium...'
cmd_exe "apt-get install -y chromium"

##########################
##      Tweeks...       ##
##########################
printf '[+] Disabling screen lock...'
cmd_exe "gsettings set org.gnome.desktop.lockdown disable-lock-screen true"

printf '[+] Disabling screensaver...'
cmd_exe "gsettings set org.gnome.desktop.session idle-delay 0"

printf '[+] Show home icon on desktop...'
cmd_exe "gsettings set org.gnome.nautilus.desktop home-icon-visible true"

printf '[+] Show trash icon on desktop...'
cmd_exe "gsettings set org.gnome.nautilus.desktop trash-icon-visible true"

printf '[+] 12 hour time...'
cmd_exe "gsettings set org.gnome.desktop.interface clock-format '12h'"

printf '[+] Changing time zone...'
cmd_exe "echo $TIMEZONE > /etc/timezone && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && dpkg-reconfigure -f noninteractive tzdata"

printf '[+] Disabling super key...'
cmd_exe "gsettings set org.gnome.mutter overlay-key ''"

printf '[+] Setting Gnome extentions...'
cmd_exe "gsettings set org.gnome.shell enabled-extensions \"['places-menu@gnome-shell-extensions.gcampax.github.com', 'refresh-wifi@kgshank.net', 'window-list@gnome-shell-extensions.gcampax.github.com', 'apps-menu@gnome-shell-extensions.gcampax.github.com', 'drive-menu@gnome-shell-extensions.gcampax.github.com', 'dash-to-dock@micxgx.gmail.com', 'user-theme@gnome-shell-extensions.gcampax.github.com']\""

printf '[+] Disabling dash-to-dock autohide...'
cmd_exe "gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true"

printf '[+] Install powerline for tmux...'
cmd_exe "install_powerline"

##########################
##    Setup configs...  ##
##########################
printf '[+] Configuring Sublime Text...'
cmd_exe "rm -rf $HOME/.config/sublime-text-3/Packages/User/ && git clone https://github.com/scott-be/Sublime-Text-3-Settings.git $HOME/.config/sublime-text-3/Packages/User/"

printf '[+] Setting up dotfiles (mc, bash, tmux, vim, etc.)...'
cmd_exe "cd $HOME && rm -rf && git clone https://github.com/scott-be/dotfiles.git && bash dotfiles/make.sh --linux && cd -"

printf '[+] Setting favorites bar...'
cmd_exe "dconf write /org/gnome/shell/favorite-apps \"['iceweasel.desktop', 'gnome-terminal.desktop', 'org.gnome.Nautilus.desktop', 'kali-msfconsole.desktop', 'kali-burpsuite.desktop', 'leafpad.desktop', 'gnome-tweak-tool.desktop', 'sublime_text.desktop', 'chromium.desktop', 'gnome-control-center.desktop']\""

##########################
##     Other stuff...   ##
##########################
printf '[+] Setting up metasploit...'
cmd_exe "/etc/init.d/postgresql start && msfdb init"

#=~=~=~=~=~=~=~=~=~=~=~=~#
## TODO
#