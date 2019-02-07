#!/bin/bash 
#===============================================================================
#
#          FILE: i3buntu.sh
# 
#         USAGE: ./i3buntu.sh 
# 
#   DESCRIPTION: I write this scrept for installation o i3-wm in ubuntu based distros
# 
#       OPTIONS: 
#  REQUIREMENTS: Ubutnu based system
#          BUGS: have to set background manually
#         NOTES: make it executable using chmod +x .i3buntu.sh
#        AUTHOR: SAGNIK SARKAR 
#  ORGANIZATION: SAGNIK SARKAR	
#       CREATED: Sunday 03 February 2019 15:10
#      REVISION:  1.0 (beta)
#===============================================================================

set -o nounset                              # Treat unset variables as an error

#  Declearing all functions

welcomemsg () {\
	dialog --title "Welcome to I3BUNTU Installation!" --msgbox "\nThis is a Auto-Rice Bootstrapping Script!\n This will automatically install a fully-featured i3-wm Ubuntu desktop , which I use on my laptop.\n\n Nil" 10 76
}

confermation_from_user (){
        dialog --title "ARE YOU SURE???" --yesno "Do you wanna continue?" 10 30 --stdout 
        confermation=$?
 }


check_update() { 
		dialog --infobox "Checking for updates..." 4 40
		sudo apt update && sudo apt upgrade 
}

i3_packges () {
	dialog --title "Installing i3 and other important packages" --msgbox "Please be parent get a cup of tee!!!!!!!" 10 76; sleep 2
	sudo apt install i3 i3lock dmenu i3blocks xinit ranger network-manager-gnome xfce4-notifyd  xfce4-power-manager gvfs gvfs-backends policykit-1 udisks2 xcompmgr rxvt-unicode-256color thunar firefox flashplugin-installer dkms vlc dtrx qbittorrent lxappearance software-properties-common feh ranger lm-sensors scrot xfce4-power-manager
}

will_install_i3gaps () {
	i3gaps=$(dialog --title "Do you want i3-gapps??Its looks good!!" --menu "please select an option" 15 55 5 1 "YES" 2 "NO" --stdout)
}
check_version () {
         	version=$(dialog --menu "Which version of Ubuntu you are using??" 10 30 30 1 "Ubuntu 16.04" 2 "Ubuntu 18.04" --stdout)
	}

Ubuntu_16_04 () {
       dialog --msgbox "Installing dependencies for I3-gaps on Ubuntu 16.04" 10 60
       sudo apt-get install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool
       dialog --msgbox "Installing libxcb-xrm-dev from source" 10 60
       mkdir tmp 
       cd tmp
       # clone the repository
       git clone https://github.com/Airblader/xcb-util-xrm
       cd xcb-util-xrm
       git submodule update --init
       ./autogen.sh --prefix=/usr
       make
       sudo make install
       rm -rf tmp
}
	
Ubuntu_18_04 () {
	dialog --msgbox "Installing dependencies for I3-gaps on Ubuntu 18.04" 10 60
	sudo apt-get install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool libxcb-xrm-dev
}

Installing_i3_gaps () {
	dialog --title "Installing I3-gapps on your ubuntu system" --infobox "Processing, please wait" 3 34; sleep 1
	#Commands for installing i3-gapps
	cd /tmp
	# clone the rewpository
	git clone https://www.github.com/Airblader/i3 i3-gaps
	cd i3-gaps
	git checkout gaps && git pull
	autoreconf --force --install
	rm -rf build
	mkdir build
	cd build
	../configure --prefix=/usr --sysconfdir=/etc
	make
	sudo make install
	rm -rf tmp

}
replaceing_config_files () {
        dialog --msgbox "Lets setup i3-wm for a rice look" 10 60
        #cloning my repo
        git clone https://github.com/007Nil/i3-wm.git
        cd i3-wm
        mv -rf feh/ i3/ ranger/ ~/.config
	mv -rf .Xresources .fonts/ ~
	cd ..
	rm -rf i3-wm
	xrdb ~/.Xresources
}
what_to_install_login_manager() {
	login=$(dialog --menu "Do you want to install login manager?" 15 40 5 1 "YES" 2 "NO" --stdout)
}

#THE MAIN PROCESS

sudo apt-get install git dialog 
#Welcome Screen
welcomemsg
#
confermation_from_user

if [ $confermation -eq 0 ]
then
	check_update
	i3_packges
	will_install_i3gaps
	if [ $i3gaps -eq 1 ]
	then
		check_version
		if [ $version -eq 1 ]
		then
			Ubuntu_16_04
		else
                        Ubuntu_18_04
		fi
        Installing_i3_gaps
        else
	       dialog --infobox "Skping i3 gaps installation"; sleep 2

        fi
        replaceing_config_files
	what_to_install_login_manager
	if [ $login -eq 1 ]
	then
		dialog --infobox "Installing lighdm as login manager" 4 40
		sudo apt-get install lightdm lightdm-gtk-greeter
	else
		dialog --infobox "After reboot start i3 by typing startx" 4 40
	fi
	dialog --infobox "Rebooting Now" 10 20
	reboot

else
        echo Never Mind. Have a nice day
	exit 0
fi

#end of script
