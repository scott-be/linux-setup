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
cmd_exe "sudo apt update && sudo apt upgrade -y"

##########################
##    Change Timezone   ##
##########################
printf '  \e[1;34m[+]\e[0m Setting Timezone...'
cmd_exe "timedatectl set-timezone $TIMEZONE"

##########################
##      App Installs... ##
##########################
printf '  \e[1;34m[+]\e[0m Installing git...'
cmd_exe "sudo apt install -y git"

printf '  \e[1;34m[+]\e[0m Installing Meld...'
cmd_exe "apt install -y meld"

printf '  \e[1;34m[+]\e[0m Installing Locate...'
cmd_exe "apt install -y locate && updatedb"

printf '  \e[1;34m[+]\e[0m Installing SSH server...'
cmd_exe "sudo apt install -y openssh-server"

printf '  \e[1;34m[+]\e[0m Disable PC Beep...'
cmd_exe "rmmod pcspkr && echo 'blacklist pcspkr' | sudo tee /etc/modprobe.d/nobeep.conf"

printf '  \e[1;34m[+]\e[0m Installing tmux...'
cmd_exe "sudo apt install -y tmux"

printf '  \e[1;34m[+]\e[0m Installing VM Tools...'
cmd_exe "sudo apt install -y open-vm-tools open-vm-tools-desktop"

printf '  \e[1;34m[+]\e[0m Installing Bash Completion...'
cmd_exe "sudo apt install -y bash-completion"

printf '  \e[1;34m[+]\e[0m Installing Sublime Text 3...'
cmd_exe "wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - && sudo apt install apt-transport-https -y && echo 'deb https://download.sublimetext.com/ apt/stable/' | sudo tee /etc/apt/sources.list.d/sublime-text.list && sudo apt update && sudo apt install sublime-text -y"

printf '  \e[1;34m[+]\e[0m Installing VS Code...'
cmd_exe "wget -O /tmp/vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868 && sudo apt install /tmp/vscode.deb; rm /tmp/vscode.deb"

printf '  \e[1;34m[+]\e[0m Installing Chromium...'
cmd_exe "sudo apt install -y chromium"

printf '  \e[1;34m[+]\e[0m Installing dconf-editor...'
cmd_exe "sudo apt install -y dconf-editor"

##########################
##    Setup configs...  ##
##########################
printf '  \e[1;34m[+]\e[0m Configuring Sublime Text...'
cmd_exe "rm -rf $HOME/.config/sublime-text-3/Packages/User/ && git clone https://github.com/scott-be/Sublime-Text-3-Settings.git $HOME/.config/sublime-text-3/Packages/User/"

printf '  \e[1;34m[+]\e[0m Setting ST3 as default...'
cmd_exe "cp resources/defaults.list $HOME/.local/share/applications/defaults.list"

printf '  \e[1;34m[+]\e[0m Setting up dotfiles (mc, bash, tmux, vim, etc.)...'
cmd_exe "cd $HOME && git clone https://github.com/scott-be/dotfiles.git && bash dotfiles/make.sh --linux && cd -"

printf '  \e[1;34m[+]\e[0m Installing powerline for tmux...'
cmd_exe "sudo apt install powerline -y && git clone https://github.com/powerline/fonts.git && fonts/install.sh && rm -rf fonts/"

printf '  \e[1;34m[+]\e[0m Install utilities for powerline...'
cmd_exe "sudo pip install psutil netifaces"

##########################
##   Meld Tweaks...   ##
##########################
printf '\e[1;4;94mMeld Tweaks\e[0m\n'
printf "  \e[1;34m[+]\e[0m Enable Word Wrap..."
cmd_exe "gsettings set org.gnome.meld wrap-mode 'char'"

printf "  \e[1;34m[+]\e[0m Highlight Current Line..."
cmd_exe "gsettings set org.gnome.meld highlight-current-line true"

printf "  \e[1;34m[+]\e[0m Enable Syntax highlighting..."
cmd_exe "gsettings set org.gnome.meld highlight-syntax true"

printf "  \e[1;34m[+]\e[0m Show Line Numbers..."
cmd_exe "gsettings set org.gnome.meld show-line-numbers true"