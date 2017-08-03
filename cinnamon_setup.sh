#!/usr/bin/env bash
# Author: Scott Bernstein - https://github.com/scott-be
# Changelog:
#   2017-20-02 - Init
#   2017-07-04 - Split install_cinnamon.sh into two files (install and setup)

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
##   Cinnamon Tweeks    ##
##########################
printf '\e[1;4;94mCinnamon Tweeks\e[0m\n'
printf '  \e[1;34m[+]\e[0m Change caps-lock to ctrl...'
cmd_exe "dconf write /org/gnome/libgnomekbd/keyboard/options \"['caps\\tcaps:ctrl_modifier']\""

printf '  \e[1;34m[+]\e[0m Set 12h Clock...'
cmd_exe "dconf write /org/cinnamon/desktop/interface/clock-use-24h false"

printf '  \e[1;34m[+]\e[0m Show computer icon...'
cmd_exe "dconf write /org/nemo/desktop/computer-icon-visible true"

printf '  \e[1;34m[+]\e[0m Show home icon...'
cmd_exe "dconf write /org/nemo/desktop/home-icon-visible true"

printf '  \e[1;34m[+]\e[0m Show trash icon...'
cmd_exe "dconf write /org/nemo/desktop/trash-icon-visible true"

printf '  \e[1;34m[+]\e[0m Show network volume icons...'
cmd_exe "dconf write /org/nemo/desktop/volumes-visible true"

printf '  \e[1;34m[+]\e[0m Set Background...'
cmd_exe "dconf write /org/cinnamon/desktop/background/picture-uri \"'file:///usr/share/desktop-base/lines-theme/wallpaper/gnome-background.xml'\""

printf '  \e[1;34m[+]\e[0m Set Window Buttons...'
cmd_exe "dconf write /org/cinnamon/muffin/button-layout \"':minimize,maximize,close'\""

printf '  \e[1;34m[+]\e[0m Set theme to BlueMenta...'
cmd_exe "dconf write /org/cinnamon/theme/name \"'BlueMenta'\""

########################
##     Nemo Tweeks    ##
########################
printf '\e[1;4;94mNemo Tweeks\e[0m\n'
printf '  \e[1;34m[+]\e[0m Show new folder icon...'
cmd_exe "gsettings set org.nemo.preferences show-new-folder-icon-toolbar true"

printf '  \e[1;34m[+]\e[0m Show open in terminal ...'
cmd_exe "gsettings set org.nemo.preferences show-open-in-terminal-toolbar true"

printf '  \e[1;34m[+]\e[0m Show reload icon...'
cmd_exe "gsettings set org.nemo.preferences show-reload-icon-toolbar true"

printf '  \e[1;34m[+]\e[0m Enable quick rename...'
cmd_exe "gsettings set org.nemo.preferences quick-renames-with-pause-in-between true"

printf '  \e[1;34m[+]\e[0m Close device view on device eject...'
cmd_exe "gsettings set org.nemo.preferences close-device-view-on-device-eject true"

## TODO
# Add icons to the bottom panel
# Remove show desktop
# 	dconf write org/cinnamon/enabled-applets "['panel1:left:0:menu@cinnamon.org:0', 'panel1:left:2:panel-launchers@cinnamon.org:2', 'panel1:left:3:window-list@cinnamon.org:3', 'panel1:right:0:notifications@cinnamon.org:4', 'panel1:right:1:user@cinnamon.org:5', 'panel1:right:2:removable-drives@cinnamon.org:6', 'panel1:right:3:keyboard@cinnamon.org:7', 'panel1:right:4:bluetooth@cinnamon.org:8', 'panel1:right:5:network@cinnamon.org:9', 'panel1:right:6:sound@cinnamon.org:10', 'panel1:right:7:power@cinnamon.org:11', 'panel1:right:8:systray@cinnamon.org:12', 'panel1:right:9:calendar@cinnamon.org:13', 'panel1:right:10:windows-quick-list@cinnamon.org:14']"