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
cmd_exe "gsettings set org.gnome.desktop.lockdown disable-lock-screen true; gsettings set apps.light-locker lock-on-suspend false"

printf '  \e[1;34m[+]\e[0m Disabling screensaver...'
cmd_exe "gsettings set org.gnome.desktop.session idle-delay 0; gsettings set apps.light-locker lock-after-screensaver 0"

printf '  \e[1;34m[+]\e[0m Show date in menu bar...'
cmd_exe "gsettings set org.gnome.desktop.interface clock-show-date true"

printf '  \e[1;34m[+]\e[0m Enable desktop icons...'
cmd_exe "gsettings set org.gnome.desktop.background show-desktop-icons true"

printf '  \e[1;34m[+]\e[0m Show home icon on desktop...'
# cmd_exe "gsettings set org.gnome.shell.extensions.desktop-icons show-home true"
cmd_exe "gsettings set org.gnome.nautilus.desktop home-icon-visible true"

printf '  \e[1;34m[+]\e[0m Show trash icon on desktop...'
# cmd_exe "gsettings set org.gnome.shell.extensions.desktop-icons show-trash true"
cmd_exe "gsettings set org.gnome.nautilus.desktop trash-icon-visible true"

printf '  \e[1;34m[+]\e[0m Set Desktop Icon Size Small...'
cmd_exe "gsettings set org.gnome.shell.extensions.desktop-icons icon-size 'small'"

printf '  \e[1;34m[+]\e[0m Setting Gnome extentions...'
cmd_exe "gsettings set org.gnome.shell enabled-extensions \"['places-menu@gnome-shell-extensions.gcampax.github.com', 'refresh-wifi@kgshank.net', 'window-list@gnome-shell-extensions.gcampax.github.com', 'apps-menu@gnome-shell-extensions.gcampax.github.com', 'drive-menu@gnome-shell-extensions.gcampax.github.com', 'dash-to-dock@micxgx.gmail.com', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'desktop-icons@csoriano']\""

printf '  \e[1;34m[+]\e[0m Disabling dash-to-dock autohide...'
cmd_exe "gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true"

printf '  \e[1;34m[+]\e[0m 12 hour time...'
cmd_exe "gsettings set org.gnome.desktop.interface clock-format '12h'"

printf '  \e[1;34m[+]\e[0m Changing time zone...'
cmd_exe "timedatectl set-timezone $TIMEZONE"

printf '  \e[1;34m[+]\e[0m Disabling super key...'
cmd_exe "gsettings set org.gnome.mutter overlay-key ''"

printf '  \e[1;34m[+]\e[0m Creating text file template...'
cmd_exe "touch $HOME/Templates/New\ Text\ File.txt"

printf '  \e[1;34m[+]\e[0m Setting caps lock as control...'
cmd_exe "gsettings set org.gnome.desktop.input-sources xkb-options \"['ctrl:nocaps']\""

printf '  \e[1;34m[+]\e[0m Disabling IPv6...'
cmd_exe "echo -e '# IPv6 disabled\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.conf && sysctl -p"

printf '  \e[1;34m[+]\e[0m Enabling Nautulus location bar...'
cmd_exe "gsettings set org.gnome.nautilus.preferences always-use-location-entry true"

printf '  \e[1;34m[+]\e[0m Disabling window snapping...'
cmd_exe "gsettings set org.gnome.mutter edge-tiling false"

printf '  \e[1;34m[+]\e[0m Setting favorites bar...'
# cmd_exe "dconf write /org/gnome/shell/favorite-apps \"['firefox-esr.desktop', 'gnome-terminal.desktop', 'org.gnome.Nautilus.desktop', 'gnome-tweak-tool.desktop', 'sublime_text.desktop', 'code.desktop', 'gnome-control-center.desktop', 'wireshark.desktop']\""
cmd_exe "dconf write /org/gnome/shell/favorite-apps \"['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'sublime-text_subl.desktop', 'gnome-control-center.desktop']\""

printf '  \e[1;34m[+]\e[0m Setting Nautilus Icon Size...'
cmd_exe "gsettings set org.gnome.nautilus.icon-view default-zoom-level 'small'"

printf '  \e[1;34m[+]\e[0m Disabling Automatic Suspend...'
cmd_exe "gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing' && gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'"

printf '  \e[1;34m[+]\e[0m Disabling Bell...'
cmd_exe "gsettings set org.gnome.desktop.wm.preferences audible-bell false"

printf '  \e[1;34m[+]\e[0m Setting Number of Workspaces...'
cmd_exe "gsettings set org.gnome.desktop.wm.preferences num-workspaces 1"

printf '  \e[1;34m[+]\e[0m Setting Static Workspaces...'
cmd_exe "gsettings set org.gnome.mutter dynamic-workspaces false"

# printf '  \e[1;34m[+]\e[0m Setting Wallpaper...'
# cmd_exe "gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/symbolics-2.jpg'"

##########################
##   gedit Tweaks...   ##
##########################
printf '\e[1;4;94mgedit Tweaks\e[0m\n'
printf "  \e[1;34m[+]\e[0m gedit Audo Indent..."
cmd_exe "gsettings set org.gnome.gedit.preferences.editor auto-indent true"

printf "  \e[1;34m[+]\e[0m gedit Highlight Matching Brackets..."
cmd_exe "gsettings set org.gnome.gedit.preferences.editor bracket-matching true"

printf "  \e[1;34m[+]\e[0m gedit Display Line Numbers..."
cmd_exe "gsettings set org.gnome.gedit.preferences.editor display-line-numbers true"

printf "  \e[1;34m[+]\e[0m gedit Highlight Current Line..."
cmd_exe "gsettings set org.gnome.gedit.preferences.editor highlight-current-line true"

printf "  \e[1;34m[+]\e[0m gedit Tab Size..."
cmd_exe "gsettings set org.gnome.gedit.preferences.editor tabs-size 4"

#################################
##   Xfce Mousepad Tweaks...   ##
#################################
printf '\e[1;4;94mXfce Mousepad Tweaks\e[0m\n'
printf "  \e[1;34m[+]\e[0m Mousepad Font..."
cmd_exe "gsettings set org.xfce.mousepad.preferences.view font-name 'Monospace 10'"

printf "  \e[1;34m[+]\e[0m Mousepad Highlight Current Line..."
cmd_exe "gsettings set org.xfce.mousepad.preferences.view highlight-current-line true"

printf "  \e[1;34m[+]\e[0m Mousepad Highlight Matching Brackets..."
cmd_exe "gsettings set org.xfce.mousepad.preferences.view match-braces true"

printf "  \e[1;34m[+]\e[0m Mousepad Display Line Numbers..."
cmd_exe "gsettings set org.xfce.mousepad.preferences.view show-line-numbers true"

printf "  \e[1;34m[+]\e[0m Mousepad Tab Size..."
cmd_exe "gsettings set org.xfce.mousepad.preferences.view tab-width 4"

printf "  \e[1;34m[+]\e[0m Mousepad Always Show Tabs..."
cmd_exe "gsettings set org.xfce.mousepad.preferences.window always-show-tabs true"

printf "  \e[1;34m[+]\e[0m Mousepad Show Statusbar..."
cmd_exe "gsettings set org.xfce.mousepad.preferences.window statusbar-visible true"

printf "  \e[1;34m[+]\e[0m Mousepad Show Toolbar..."
cmd_exe "gsettings set org.xfce.mousepad.preferences.window toolbar-visible true"


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