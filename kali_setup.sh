##########################
##      Variables       ##
##########################
SUBLIME_URL="http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb"
TIMEZONE="America/New_York"

##########################
## First things first...##
##########################
# Change password
passwd

# Update Kali
apt-get update && apt-get upgrade -y

##########################
##      App Installs... ##
##########################
# Install SSH server
apt-get install -y openssh-server

# Install sublime text 3
wget -O ~/sublime_text_3.deb $SUBLIME_URL && sudo dpkg -i ~/sublime_text_3.deb && rm ~/sublime_text_3.deb

# Install Chromium
apt-get install -y chromium

##########################
##       Tweeks...      ##
##########################
# Disable screen lock
gsettings set org.gnome.desktop.lockdown disable-lock-screen true

# Disable screensaver
gsettings set org.gnome.desktop.session idle-delay 0

# Show home icon on desktop
gsettings set org.gnome.nautilus.desktop home-icon-visible true

# Show trash icon on desktop
gsettings set org.gnome.nautilus.desktop trash-icon-visible true

# 12 hour time
gsettings set org.gnome.desktop.interface clock-format '12h'

# Change time zone
echo $TIMEZONE > /etc/timezone && ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

##########################
##    Setup configs...  ##
##########################

##########################
##     Other stuff...   ##
##########################
# Set up metasploit
/etc/init.d/postgresql start
msfdb init


#=~=~=~=~=~=~=~=~=~=~=~=~#
## TODO
# Disable the Intelligent Sidebar Option
# Set favorites bar
	# dconf read /org/gnome/shell/favorite-apps
	# dconf write /org/gnome/shell/favorite-apps "[]"
# Set gedit preferences
# Set bash profile
# Set tmux settings
# Set Sublime Text settings
# Set vim settings
# Change hostname
	# http://www.blackmoreops.com/2013/12/12/change-hostname-kali-linux/#Change_hostname_permanently_without_reboot
# disable double command expose

## Notes

# cat <<EOF > /usr/share/applications/sublime_text.desktop
# [Desktop Entry]
# Version=1.0
# Type=Application
# Name=Sublime Text
# GenericName=Text Editor
# Comment=Sophisticated text editor for code, markup and prose
# Exec=/opt/sublime_text/sublime_text %F
# Terminal=false
# MimeType=text/plain;
# Icon=sublime-text
# Categories=TextEditor;Development;
# StartupNotify=true
# Actions=Window;Document;

# [Desktop Action Window]
# Name=New Window
# Exec=/opt/sublime_text/sublime_text -n
# OnlyShowIn=Unity;

# [Desktop Action Document]
# Name=New File
# Exec=/opt/sublime_text/sublime_text --command new_file
# OnlyShowIn=Unity;
# EOF
# chmod +x /usr/share/applications/sublime_text.desktop

