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

printf '  \e[1;34m[+]\e[0m Disable PC Beep...'
cmd_exe "rmmod pcspkr && echo 'blacklist pcspkr' | sudo tee /etc/modprobe.d/nobeep.conf"

printf '  \e[1;34m[+]\e[0m Installing tmux...'
cmd_exe "sudo apt-get install -y tmux"

printf '  \e[1;34m[+]\e[0m Installing VM Tools...'
cmd_exe "sudo apt-get install -y open-vm-tools open-vm-tools-desktop"

printf '  \e[1;34m[+]\e[0m Installing Sublime Text 3...'
cmd_exe "wget -O $HOME/sublime_text_3.deb $SUBLIME_URL && sudo dpkg -i $HOME/sublime_text_3.deb && rm $HOME/sublime_text_3.deb"

printf '  \e[1;34m[+]\e[0m Installing Chromium...'
cmd_exe "sudo apt-get install -y chromium"

##########################
##    Setup configs...  ##
##########################
printf '  \e[1;34m[+]\e[0m Configuring Sublime Text...'
cmd_exe "rm -rf $HOME/.config/sublime-text-3/Packages/User/ && git clone https://github.com/scott-be/Sublime-Text-3-Settings.git $HOME/.config/sublime-text-3/Packages/User/"

printf '  \e[1;34m[+]\e[0m Setting up dotfiles (mc, bash, tmux, vim, etc.)...'
cmd_exe "cd $HOME && git clone https://github.com/scott-be/dotfiles.git && bash dotfiles/make.sh --linux && cd -"