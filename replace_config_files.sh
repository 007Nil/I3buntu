#!/bin/bash - 
#===============================================================================
#
#          FILE: replace_config_files.sh
# 
#         USAGE: ./replace_config_files.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: 
#  REQUIREMENTS: firsh you need to execute i3buntu.sh
#          BUGS: no bugs
#         NOTES: this will replace all config fies
#        AUTHOR: Sagnik Sarkar
#  ORGANIZATION: 
#       CREATED: Wednesday 20 February 2019 21:50
#      REVISION:  rev 1
#===============================================================================

set -o nounset                              # Treat unset variables as an error
replaceing_config_files () {
         dialog --msgbox "Lets setup i3-wm for a rice look" 10 60
         #cloning my repo
         git clone https://github.com/007Nil/i3-wm.git
         cd i3-wm
         cp -rf feh/ i3/ ranger/ ~/.config/
         cp -rf .Xresources .fonts/ wallpapers/ ~
         cd ..
         chmod +x .config/i3/lock
         chmod +x .config/i3/cpu_temp
         rm -rf i3-wm
         xrdb ~/.Xresources
 }

replaceing_config_files

#end of script
