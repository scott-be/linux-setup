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
TIMEZONE="America/New_York"

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

printf '  \e[1;34m[+]\e[0m Setting Gnome extentions...'
cmd_exe "gsettings set org.gnome.shell enabled-extensions \"['places-menu@gnome-shell-extensions.gcampax.github.com', 'refresh-wifi@kgshank.net', 'window-list@gnome-shell-extensions.gcampax.github.com', 'apps-menu@gnome-shell-extensions.gcampax.github.com', 'drive-menu@gnome-shell-extensions.gcampax.github.com', 'dash-to-dock@micxgx.gmail.com', 'user-theme@gnome-shell-extensions.gcampax.github.com']\""

printf '  \e[1;34m[+]\e[0m Disabling dash-to-dock autohide...'
cmd_exe "dconf write /org/gnome/shell/extensions/dash-to-dock/dock-fixed true"

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

printf '  \e[1;34m[+]\e[0m Disabling dash-to-dock autohide...'
cmd_exe "dconf write /org/gnome/shell/extensions/dash-to-dock/dock-fixed true"

printf '  \e[1;34m[+]\e[0m Enabling Nautulus location bar...'
cmd_exe "gsettings set org.gnome.nautilus.preferences always-use-location-entry true"

printf '  \e[1;34m[+]\e[0m Disabling window snapping...'
cmd_exe "gsettings set org.gnome.shell.overrides edge-tiling false"

printf '  \e[1;34m[+]\e[0m Setting favorites bar...'
cmd_exe "dconf write /org/gnome/shell/favorite-apps \"['firefox-esr.desktop', 'gnome-terminal.desktop', 'org.gnome.Nautilus.desktop', 'gnome-tweak-tool.desktop', 'sublime_text.desktop', 'gnome-control-center.desktop', 'wireshark.desktop']\""

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
printf '  \e[1;34m[+]\e[0m Changing gnome-terminal profile...'
cmd_exe "dconf load /org/gnome/terminal/legacy/profiles:/ < resources/monokai-soda.xml"
# Use `dconf dump /org/gnome/terminal/legacy/profiles:/ > ~/Desktop/monokai-soda.xml` to export the current gnome-terminal settings.

##########################
##     Other Scripts    ##
##########################
read -p $'  \e[1;34m[>]\e[0m Run install-applications-general.sh?...(Y/n)' -r
if [[ $REPLY == "Y" || $REPLY == "y" || -z $REPLY ]]; then
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	"$DIR/install-applications-general.sh"
fi


#=~=~=~=~=~=~=~=~=~=~=~=~#
## TODO
	# install/enable gnome extentions (side bar; stuff like that)
	# install https://extensions.gnome.org/extension/120/system-monitor/
	# enable extensions
		# gsettings get org.gnome.shell enabled-extensions
		# gsettings set org.gnome.shell enabled-extensions "['weather-extension@xeked.com', 'axemenu@wheezy', 'removeaccesibility@lomegor']"
	# https://extensions.gnome.org/extension/584/taskbar/