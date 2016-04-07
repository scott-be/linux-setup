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
SUBLIME_URL="https://download.sublimetext.com/sublime-text_build-3103_amd64.deb" ## ST3 Build 3103 64 bit
TIMEZONE="America/New_York"

##########################
##        Setup         ##
##########################
printf '\e[1;4;94mSetup\e[0m\n'
CURRENT_PASS=`grep -w root /etc/shadow | cut -d: -f2`
export SALT=`grep -w root /etc/shadow | cut -d$ -f3`
GENPASS=$(perl -le 'print crypt("toor","\$6\$$ENV{SALT}\$")')
if [ $GENPASS == $CURRENT_PASS ]; then
	printf '  [+] Change password...\n'
	passwd
fi

printf '  [+] Updating Kali (may take a while)...'
cmd_exe "apt-get update && apt-get upgrade -y"

if [ $HOSTNAME == "kali" ]; then 
	printf '  [+] Change hostname...\n'
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
printf '\e[1;4;94mApp Installs\e[0m\n'
printf '  [+] Installing SSH server...'
cmd_exe "apt-get install -y openssh-server"

printf '  [+] Installing Sublime Text 3...'
cmd_exe "wget -O $HOME/sublime_text_3.deb $SUBLIME_URL && sudo dpkg -i $HOME/sublime_text_3.deb && rm $HOME/sublime_text_3.deb"

printf '  [+] Installing cifs-utils...'
cmd_exe "apt-get install cifs-utils -y"

printf '  [+] Install mana-toolkit...'
cmd_exe "apt-get install mana-toolkit -y"

printf '  [+] Installing shareenum...'
cmd_exe "wget -O /var/tmp/shareenum_2.0_amd64.deb https://github.com/CroweCybersecurity/shareenum/releases/download/2.0/shareenum_2.0_amd64.deb && dpkg -i /var/tmp/shareenum_2.0_amd64.deb && rm /var/tmp/shareenum_2.0_amd64.deb"

printf '  [+] Installing Impacket...'
cmd_exe "git clone https://github.com/CoreSecurity/impacket.git /sbtools/impacket && python /sbtools/impacket/setup.py install"

printf '  [+] Install net-creds...'
cmd_exe "git clone https://github.com/DanMcInerney/net-creds.git /sbtools/net-creds"

printf '  [+] Installing BetterCAP...'
cmd_exe "sudo apt-get install build-essential ruby-dev libpcap-dev && gem install bettercap"

##########################
##    Gnome Tweaks...   ##
##########################
printf '\e[1;4;94mGnome Tweaks\e[0m\n'
printf '  [+] Disabling screen lock...'
cmd_exe "gsettings set org.gnome.desktop.lockdown disable-lock-screen true"

printf '  [+] Disabling screensaver...'
cmd_exe "gsettings set org.gnome.desktop.session idle-delay 0"

printf '  [+] Show home icon on desktop...'
cmd_exe "gsettings set org.gnome.nautilus.desktop home-icon-visible true"

printf '  [+] Show trash icon on desktop...'
cmd_exe "gsettings set org.gnome.nautilus.desktop trash-icon-visible true"

printf '  [+] Setting Gnome extentions...'
cmd_exe "gsettings set org.gnome.shell enabled-extensions \"['places-menu@gnome-shell-extensions.gcampax.github.com', 'refresh-wifi@kgshank.net', 'window-list@gnome-shell-extensions.gcampax.github.com', 'apps-menu@gnome-shell-extensions.gcampax.github.com', 'drive-menu@gnome-shell-extensions.gcampax.github.com', 'dash-to-dock@micxgx.gmail.com', 'user-theme@gnome-shell-extensions.gcampax.github.com']\""

printf '  [+] Disabling dash-to-dock autohide...'
cmd_exe "gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true"

printf '  [+] Enabling Nautulus location bar...'
cmd_exe "gsettings set org.gnome.nautilus.preferences always-use-location-entry true"

printf '  [+] Disabling window snapping...'
cmd_exe "gsettings set org.gnome.shell.overrides edge-tiling false"

printf '  [+] Setting favorites bar...'
cmd_exe "dconf write /org/gnome/shell/favorite-apps \"['iceweasel.desktop', 'gnome-terminal.desktop', 'org.gnome.Nautilus.desktop', 'gnome-tweak-tool.desktop', 'sublime_text.desktop', 'gnome-control-center.desktop']\""

##########################
##   gedit Tweaks...   ##
##########################
printf '\e[1;4;94mgedit Tweaks\e[0m\n'
printf "  [+] gedit Audo Indent..."
cmd_exe "gsettings set org.gnome.gedit.preferences.editor auto-indent true"

printf "  [+] gedit Highlight Matching Brackets ..."
cmd_exe "gsettings set org.gnome.gedit.preferences.editor bracket-matching true"

printf "  [+] gedit Display Line Numbers..."
cmd_exe "gsettings set org.gnome.gedit.preferences.editor display-line-numbers true"

printf "  [+] gedit Highlight Current Line..."
cmd_exe "gsettings set org.gnome.gedit.preferences.editor highlight-current-line true"

printf "  [+] gedit Tab Size..."
cmd_exe "gsettings set org.gnome.gedit.preferences.editor tabs-size 4"

##########################
##   System Tweaks...   ##
##########################
printf '\e[1;4;94mSystem Tweaks\e[0m\n'
printf '  [+] 12 hour time...'
cmd_exe "gsettings set org.gnome.desktop.interface clock-format '12h'"

printf '  [+] Changing time zone...'
cmd_exe "echo $TIMEZONE > /etc/timezone && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && dpkg-reconfigure -f noninteractive tzdata"

printf '  [+] Disabling super key...'
cmd_exe "gsettings set org.gnome.mutter overlay-key ''"

printf '  [+] Creating text file template...'
cmd_exe "touch $HOME/Templates/New\ Text\ File.txt"

printf '  [+] Setting caps lock as control...'
cmd_exe "gsettings set org.gnome.desktop.input-sources xkb-options \"['ctrl:nocaps']\""

##########################
##     Eye Candy...     ##
##########################
printf '\e[1;4;94mEye Candy\e[0m\n'
printf '  [+] Installing powerline for tmux...'
cmd_exe "apt-get install powerline -y && git clone https://github.com/powerline/fonts.git && fonts/install.sh && rm -rf fonts/"

printf '  [+] Changing gnome-terminal profile...'
cmd_exe "dconf load /org/gnome/terminal/legacy/profiles:/ < resources/monokai-soda.xml"
# Use `dconf dump /org/gnome/terminal/legacy/profiles:/ > ~/Desktop/monokai-soda.xml` to export the current gnome-terminal settings.

##########################
##    Setup configs...  ##
##########################
printf '\e[1;4;94mConfigs\e[0m\n'
printf '  [+] Configuring Sublime Text...'
cmd_exe "rm -rf $HOME/.config/sublime-text-3/Packages/User/ && git clone https://github.com/scott-be/Sublime-Text-3-Settings.git $HOME/.config/sublime-text-3/Packages/User/"

printf '  [+] Setting up dotfiles (mc, bash, tmux, vim, etc.)...'
cmd_exe "cd $HOME && rm -rf && git clone https://github.com/scott-be/dotfiles.git && bash dotfiles/make.sh --linux && cd -"

##########################
##     Other stuff...   ##
##########################
printf '\e[1;4;94mOther Stuff\e[0m\n'
printf '  [+] Setting up metasploit...'
cmd_exe "/etc/init.d/postgresql start && msfdb init"

#=~=~=~=~=~=~=~=~=~=~=~=~#
## TODO
# Install gnome-terminal theme
# Set theme as default
# Disable terminal bell
# Disable network manager
# Disable IPv6
