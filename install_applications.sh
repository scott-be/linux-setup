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
## First things first...##
##########################
printf '  \e[1;34m[+]\e[0m Updating Linux...'
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

printf '  \e[1;34m[+]\e[0m Installing Bash Completion...'
cmd_exe "sudo apt-get install -y bash-completion"

printf '  \e[1;34m[+]\e[0m Installing Sublime Text 3...'
cmd_exe "wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - && sudo apt-get install apt-transport-https -y && echo 'deb https://download.sublimetext.com/ apt/stable/' | sudo tee /etc/apt/sources.list.d/sublime-text.list && sudo apt update && sudo apt install sublime-text -y"

printf '  \e[1;34m[+]\e[0m Installing Chromium...'
cmd_exe "sudo apt-get install -y chromium"

##########################
##    Setup configs...  ##
##########################
printf '  \e[1;34m[+]\e[0m Configuring Sublime Text...'
cmd_exe "rm -rf $HOME/.config/sublime-text-3/Packages/User/ && git clone https://github.com/scott-be/Sublime-Text-3-Settings.git $HOME/.config/sublime-text-3/Packages/User/"

printf '  \e[1;34m[+]\e[0m Setting up dotfiles (mc, bash, tmux, vim, etc.)...'
cmd_exe "cd $HOME && git clone https://github.com/scott-be/dotfiles.git && bash dotfiles/make.sh --linux && cd -"

printf '  \e[1;34m[+]\e[0m Installing powerline for tmux...'
cmd_exe "sudo apt-get install powerline -y && git clone https://github.com/powerline/fonts.git && fonts/install.sh && rm -rf fonts/"

printf '  \e[1;34m[+]\e[0m Install utilities for powerline...'
cmd_exe "sudo pip install psutil netifaces"