cmd_exe () {
	eval $@ >/dev/null 2>&1
	# echo $1
	if [ $? -eq 0 ]; then
		printf "[\033[32mOK\033[0m]\n"
	else
		printf "[\033[31mFAIL\033[0m]\n"
	fi
}

##########################
##      Variables       ##
##########################
SUBLIME_URL="http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb"
TIMEZONE="America/New_York"

##########################
## First things first...##
##########################
printf '[+] Change password...\n'
passwd

printf '[+] Updating Kali...'
cmd_exe "apt-get update && apt-get upgrade -y"

##########################
##      App Installs... ##
##########################
printf '[+] Installing SSH server...'
cmd_exe "apt-get install -y openssh-server"

printf '[+] Installing Sublime Text 3...'
cmd_exe "wget -O $HOME/sublime_text_3.deb $SUBLIME_URL && sudo dpkg -i $HOME/sublime_text_3.deb && rm $HOME/sublime_text_3.deb"

printf '[+] Installing Chromium...'
cmd_exe "apt-get install -y chromium"

##########################
##       Tweeks...      ##
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

##########################
##    Setup configs...  ##
##########################
printf '[+] Configuring Sublime Text...'
cmd_exe "rm -rf $HOME/.config/sublime-text-3/Packages/User/ && git clone https://github.com/scott-be/Sublime-Text-3-Settings.git $HOME/.config/sublime-text-3/Packages/User/"

printf '[+] Setting up dotfiles (mc, bash, tmux, vim, etc.)...'
cmd_exe "cd $HOME && git clone https://github.com/scott-be/dotfiles.git && bash dotfiles/make.sh --linux && cd -"

##########################
##     Other stuff...   ##
##########################
printf '[+] Setting up metasploit...'
cmd_exe "/etc/init.d/postgresql start && msfdb init"


#=~=~=~=~=~=~=~=~=~=~=~=~#
## TODO
# Disable the Intelligent Sidebar Option
# Set favorites bar
	# dconf read /org/gnome/shell/favorite-apps
	# dconf write /org/gnome/shell/favorite-apps "['iceweasel.desktop', 'gnome-terminal.desktop', 'org.gnome.Nautilus.desktop', 'kali-msfconsole.desktop', 'kali-burpsuite.desktop', 'leafpad.desktop', 'gnome-tweak-tool.desktop', 'sublime_text.desktop', 'chromium.desktop', 'gnome-control-center.desktop']"
# Change hostname
	# http://www.blackmoreops.com/2013/12/12/change-hostname-kali-linux/#Change_hostname_permanently_without_reboot