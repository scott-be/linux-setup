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
SUBLIME_URL="https://download.sublimetext.com/sublime-text_build-3126_amd64.deb" ## ST3 Build 3126 64 bit
TIMEZONE="America/New_York"

##########################
## First things first...##
##########################
printf '  \e[1;34m[+]\e[0m Updating Ubuntu...'
cmd_exe "sudo apt-get update && sudo apt-get upgrade -y"

##########################
##      App Installs... ##
##########################
printf '  \e[1;34m[+]\e[0m Installing git...'
cmd_exe "sudo apt-get install -y git"

printf '  \e[1;34m[+]\e[0m Installing SSH server...'
cmd_exe "sudo apt-get install -y openssh-server"

printf '  \e[1;34m[+]\e[0m Installing Sublime Text 3...'
cmd_exe "wget -O $HOME/sublime_text_3.deb $SUBLIME_URL && sudo dpkg -i $HOME/sublime_text_3.deb && rm $HOME/sublime_text_3.deb"

printf '  \e[1;34m[+]\e[0m Installing Chromium...'
cmd_exe "sudo apt-get install -y chromium"

##########################
##       Tweeks...      ##
##########################
printf '  \e[1;34m[+]\e[0m Disabling screen lock...'
cmd_exe "gsettings set org.gnome.desktop.lockdown disable-lock-screen true"

printf '  \e[1;34m[+]\e[0m Disabling screensaver...'
cmd_exe "gsettings set org.gnome.desktop.session idle-delay 0"

printf '  \e[1;34m[+]\e[0m Show date in menu bar...'
cmd_exe "gsettings set org.gnome.desktop.interface clock-show-date true"

printf '  \e[1;34m[+]\e[0m Enable desktop icons...'
cmd_exe "gsettings set org.gnome.desktop.background show-desktop-icons true"

printf '  \e[1;34m[+]\e[0m Show home icon on desktop...'
cmd_exe "gsettings set org.gnome.nautilus.desktop home-icon-visible true"

printf '  \e[1;34m[+]\e[0m Show trash icon on desktop...'
cmd_exe "gsettings set org.gnome.nautilus.desktop trash-icon-visible true"

printf '  \e[1;34m[+]\e[0m Add minimize, maximize, close buttons to windows...'
cmd_exe "gsettings set  org.gnome.shell.overrides button-layout ':minimize,maximize,close'"

printf '  \e[1;34m[+]\e[0m 12 hour time...'
cmd_exe "gsettings set org.gnome.desktop.interface clock-format '12h'"

printf '  \e[1;34m[+]\e[0m Changing time zone...'
cmd_exe "echo $TIMEZONE > /etc/timezone && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && dpkg-reconfigure -f noninteractive tzdata"

printf '  \e[1;34m[+]\e[0m Disabling super key...'
cmd_exe "gsettings set org.gnome.mutter overlay-key ''"

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
printf '  \e[1;34m[+]\e[0m Configuring Sublime Text...'
cmd_exe "rm -rf $HOME/.config/sublime-text-3/Packages/User/ && git clone https://github.com/scott-be/Sublime-Text-3-Settings.git $HOME/.config/sublime-text-3/Packages/User/"

printf '  \e[1;34m[+]\e[0m Setting up dotfiles (mc, bash, tmux, vim, etc.)...'
cmd_exe "cd $HOME && git clone https://github.com/scott-be/dotfiles.git && bash dotfiles/make.sh --linux && cd -"


#=~=~=~=~=~=~=~=~=~=~=~=~#
## TODO
	# refresh clock?
	# reboot?
	# install/enable gnome extentions (side bar; stuff like that)
	# install https://extensions.gnome.org/extension/120/system-monitor/
	# enable extensions
		# gsettings get org.gnome.shell enabled-extensions
		# gsettings set org.gnome.shell enabled-extensions "['weather-extension@xeked.com', 'axemenu@wheezy', 'removeaccesibility@lomegor']"
	# https://extensions.gnome.org/extension/584/taskbar/

