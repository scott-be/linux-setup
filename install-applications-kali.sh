#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
##   App Installs...    ##
##########################
printf '\e[1;4;94mApp Installs\e[0m\n'
printf '  \e[1;34m[+]\e[0m Installing cifs-utils...'
cmd_exe "apt-get install cifs-utils -y"

printf '  \e[1;34m[+]\e[0m Installing shareenum...'
cmd_exe "wget -O /var/tmp/shareenum_2.0_amd64.deb https://github.com/CroweCybersecurity/shareenum/releases/download/2.0/shareenum_2.0_amd64.deb && dpkg -i /var/tmp/shareenum_2.0_amd64.deb && rm /var/tmp/shareenum_2.0_amd64.deb"

printf '  \e[1;34m[+]\e[0m Install mana-toolkit...'
cmd_exe "apt-get install mana-toolkit -y && ln -s /usr/share/mana-toolkit/ /sbtools/mana-toolkit"

printf '  \e[1;34m[+]\e[0m Install go...'
cmd_exe "apt-get install golang -y"

printf '  \e[1;34m[+]\e[0m Install bettercap...'
cmd_exe "apt-get install bettercap -y"


printf '\e[1;4;94mCloning repos\e[0m\n'
mkdir -p /sbtools
cd /sbtools

while read l; do
	printf '  \e[1;34m[+]\e[0m Cloning %s\n' $l
	git clone $l -q
done < $DIR/resources/github-repos-kali.txt

cd $DIR

# TODO
# [ ] Loop github repos file (resources/github-repos-kali.txt)
# [ ] Install Impacket - cd /sbtools/impacket/ && python setup.py install
## Install (requires interaction)
# [ ] Install Empire - /sbtools/Empire/setup/install.sh
# [ ] Install Empire - /sbtools/Veil/setup/setup.sh